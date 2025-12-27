vim = vim

local function build_filename(note_type, args)
  local short_type = note_type.name:sub(1, 3)
  local timestr = (os.date '%Y%m%d%H%M'):sub(3)
  local title_table = {}
  for i = 1, #args do
    title_table[i] = string.lower(args[i]):gsub('[^a-zA-Z0-9]', '')
  end
  return timestr .. '-' .. short_type .. '-' .. table.concat(title_table, '-') .. '.md'
end

local function build_file_content(note_type, args, current_filepath)
  local fields = vim.split(note_type.fields, ':', true)
  local rtn = { '---' }
  local now_date = os.date '%Y-%m-%d'
  local filepath_bits = vim.split(current_filepath, '/')
  local current_filename = filepath_bits[#filepath_bits]
  local specials = {
    title = table.concat(args, ' '),
    date = now_date,
    start_date = now_date,
    thread = current_filename,
  }
  for _, field in ipairs(fields) do
    local field_value = ''
    if specials[field] ~= nil then
      field_value = ' ' .. specials[field]
    end
    table.insert(rtn, field .. ':' .. field_value)
  end
  table.insert(rtn, '---')
  if note_type.body then
    rtn = vim.list_extend(rtn, vim.split(note_type.body, '\n', true))
  end
  return rtn
end

local function tbl_concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local function find_markdown_links(text)
  local results = {}
  local pattern = '%[(.-)%]%s*(%b())'
  local search_start = 1

  while true do
    local s, e, label, href = text:find(pattern, search_start)
    if not s then
      break
    end

    -- Remove parentheses from href
    href = href:sub(2, -2)

    table.insert(results, {
      start_idx = s,
      end_idx = e,
      label = label,
      href = href,
    })

    search_start = e + 1
  end

  return results
end

local function parse_note_filename(filename)
  local id_end = string.find(filename, '-')
  local type_end = string.find(filename, '-', id_end + 1)
  return {
    id = filename:sub(1, id_end - 1),
    note_type = filename:sub(id_end + 1, type_end - 1),
    name = filename:sub(type_end + 1):gsub('.md', ''),
  }
end

local function load_config()
  local config_files = { vim.g.NotesConfig }
  local rtn = { note_types = {} }
  while #config_files > 0 do
    local config_file = config_files[1]
    local basedir = vim.fs.dirname(config_file)
    table.remove(config_files, 1)
    local fh = io.open(config_file, 'r')
    if not fh then
      return rtn
    end
    local data = vim.fn.json_decode(vim.trim(fh:read 'a'))
    for _, note_type in ipairs(data.note_types) do
      note_type.location = basedir .. '/' .. note_type.location
      table.insert(rtn.note_types, note_type)
    end
    config_files = tbl_concat(config_files, data['includes'])
    fh:close()
  end
  return rtn
end

local function list_note_files(config, included_prefixes)
  local rtn = {}
  for _, note_type in pairs(config.note_types) do
    local matches = true
    if included_prefixes then
      matches = false
      for _, prefix in pairs(included_prefixes) do
        if note_type.name:sub(1, #prefix) == prefix then
          matches = true
          break
        end
      end
    end

    if matches then
      local dir = vim.uv.fs_opendir(note_type.location)
      while true do
        local entries = vim.uv.fs_readdir(dir)
        if entries == nil then
          break
        end
        for _, entry in pairs(entries) do
          if entry.type == 'file' then
            table.insert(rtn, {
              filename = entry.name,
              filepath = note_type.location .. '/' .. entry.name,
            })
          end
        end
      end
    end
  end
  return rtn
end

local function cmd_completions(arglead, _, _)
  if arglead:find(' ', 1, true) ~= nil then
    -- No autocomplete beyond the type
    return {}
  end

  local data = load_config()
  local rtn = {}
  for _, note_type in ipairs(data.note_types) do
    table.insert(rtn, note_type.name)
  end
  if #arglead > 0 then
    table.sort(rtn, function(a, _)
      if a:sub(1, #arglead) == arglead then
        return true
      else
        return false
      end
    end)
  end
  return rtn
end

vim.api.nvim_create_user_command('Nn', function(opts)
  if #opts.fargs < 2 then
    return
  end

  local data = load_config()

  for _, note_type in ipairs(data.note_types) do
    if note_type.name:sub(1, #opts.fargs[1]) == opts.fargs[1] then
      local rest = vim.list_slice(opts.fargs, 2)
      local filename = note_type.location .. '/' .. build_filename(note_type, rest)
      local current_filepath = vim.api.nvim_buf_get_name(vim.fn.bufnr())
      local filecontent = build_file_content(note_type, rest, current_filepath)
      vim.cmd.e(filename)
      vim.api.nvim_buf_set_lines(vim.fn.bufnr(), 0, -1, false, filecontent)
      break
    end
  end
end, { nargs = '+', complete = cmd_completions })

--- LSP

local function calculate_anchor_depth(s)
  local depth = 0
  local idx = 1
  local maxint = 9223372036854775807
  while true do
    local maybe_open = string.find(s, ']%(', idx) or maxint
    local maybe_close = string.find(s, '%)', idx) or maxint
    if maybe_open < maybe_close then
      depth = depth + 1
      idx = maybe_open + 2
    elseif maybe_close == maxint then
      -- End of string
      break
    else
      depth = math.max(0, depth - 1)
      idx = maybe_close + 1
    end
  end
  return depth
end

local lsp_helper = require 'plugin._lsp_helper'
lsp_helper.register_in_process_lsp('notes', {
  filetypes = { 'markdown' },
  root_dir = function(_, on_dir)
    -- Only enable the LSP if we're in a notes directory, and otherwise
    -- share a single instance
    local config = load_config()
    local current_filepath = vim.api.nvim_buf_get_name(vim.fn.bufnr())
    for _, note_type in pairs(config.note_types) do
      local loc = note_type.location
      if current_filepath:sub(1, #loc) == loc then
        on_dir(vim.fs.dirname(vim.g.NotesConfig))
      end
    end
  end,
  handlers = {
    definition = function(_, callback)
      local line = vim.fn.getline '.'
      local curpos = vim.fn.getcurpos()
      local maybe_hovered_link = nil
      for _, match in ipairs(find_markdown_links(line)) do
        if (match.start_idx <= curpos[3]) and (curpos[3] <= match.end_idx) then
          maybe_hovered_link = match
          break
        end
      end
      if maybe_hovered_link == nil then
        return
      end

      local config = load_config()
      local link_data = parse_note_filename(maybe_hovered_link.href)
      local maybe_filepath = nil
      for _, file in pairs(list_note_files(config, { link_data.note_type })) do
        local filename_data = parse_note_filename(file.filename)
        if link_data.id == filename_data.id then
          maybe_filepath = file.filepath
        end
      end

      if maybe_filepath then
        local file_uri = 'file://' .. maybe_filepath
        local range = {
          start = { line = 0, character = 0 },
          ['end'] = { line = 0, character = 0 },
        }
        callback(nil, { uri = file_uri, range = range })
      end
    end,
    completion = function(_, callback)
      local curpos = vim.fn.getcurpos()[3]
      local truncline = vim.fn.getline('.'):sub(1, curpos - 1)
      local depth = calculate_anchor_depth(truncline)

      if depth > 0 then
        local config = load_config()
        local rtn = {}
        for _, file in pairs(list_note_files(config)) do
          table.insert(rtn, {
            label = file.filename,
          })
        end
        callback(nil, rtn)
      end
    end,
  },
})
