vim = vim

local function build_filename(note_type, args)
  local filename_template = note_type.filename_template or '%y%m%d%H%M-%short_type%-%title%.md'
  local short_type = note_type.name:sub(1, 3)
  local title_table = {}
  for i = 1, #args do
    title_table[i] = string.lower(args[i]):gsub('[^a-zA-Z0-9]', '')
  end
  local title = table.concat(title_table, '-')
  local pre_date = filename_template:gsub('%%title%%', title):gsub('%%short_type%%', short_type):gsub('%%y', os.date('%Y'):sub(3))
  return os.date(pre_date)
end

local function build_file_content(note_type, args, current_filepath)
  local rtn = {}
  if note_type.fields then
    local fields = vim.split(note_type.fields, ':', true)
    local now_date = os.date '%Y-%m-%d'
    local filepath_bits = vim.split(current_filepath, '/')
    local current_filename = filepath_bits[#filepath_bits]
    local specials = {
      title = table.concat(args, ' '),
      date = now_date,
      start_date = now_date,
      thread = current_filename,
    }
    table.insert(rtn, '---')
    for _, field in ipairs(fields) do
      local field_value = ''
      if specials[field] ~= nil then
        field_value = ' ' .. specials[field]
      end
      table.insert(rtn, field .. ':' .. field_value)
    end
    table.insert(rtn, '---')
  end
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

local function find_links(text)
  local results = {}
  local covered_ranges = {}

  local md_pattern = '%[(.-)%]%((.-)%)'

  local trace_pattern = '%d%d%d%d%d%d%d%d%d%d%-[a-z][a-z][a-z]%-[%w%-%.]*'

  local function is_covered(s, e)
    for _, range in ipairs(covered_ranges) do
      if not (e < range.s or s > range.e) then
        return true
      end
    end
    return false
  end

  local function mark_covered(s, e)
    table.insert(covered_ranges, { s = s, e = e })
  end

  local search_start = 1
  while true do
    local s, e, label, href = text:find(md_pattern, search_start)
    if not s then
      break
    end

    table.insert(results, {
      start_idx = s,
      end_idx = e,
      label = label,
      href = href,
    })

    mark_covered(s, e)
    search_start = e + 1
  end

  search_start = 1
  while true do
    local s, e = text:find(trace_pattern, search_start)
    if not s then
      break
    end

    if not is_covered(s, e) then
      table.insert(results, {
        start_idx = s,
        end_idx = e,
        label = nil,
        href = text:sub(s, e),
      })
    end

    search_start = e + 1
  end

  table.sort(results, function(a, b)
    return a.start_idx < b.start_idx
  end)

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

local function extract_tags(file_content)
  if not file_content then
    return {}
  end

  -- Match tags field in frontmatter (between --- delimiters)
  local frontmatter = file_content:match '^%-%-%-\n(.-)%-%-%-'
  if not frontmatter then
    return {}
  end

  local s, e = frontmatter:find 'tags:'
  if not s or (s ~= 1 and frontmatter:sub(s - 1, s - 1) ~= '\n') then
    return {}
  end
  s = e + 1
  e = frontmatter:find('\n', s)
  local body = frontmatter:sub(s, e)

  local tags = {}
  for tag in body:gmatch '[^%s,]+' do
    tag = tag:gsub('^#', '')
    if tag ~= '' then
      table.insert(tags, tag)
    end
  end

  return tags
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
  local rtn = { 'tags' }
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

local function create_note(config, args)
  for _, note_type in ipairs(config.note_types) do
    if note_type.name:sub(1, #args[1]) == args[1] then
      local title = vim.list_slice(args, 2)
      if #title == 0 then
        title = { 'untitled' }
      end
      local filename = note_type.location .. '/' .. build_filename(note_type, title)
      local current_filepath = vim.api.nvim_buf_get_name(vim.fn.bufnr())
      local filecontent = build_file_content(note_type, title, current_filepath)
      vim.cmd.e(filename)
      vim.api.nvim_buf_set_lines(vim.fn.bufnr(), 0, -1, false, filecontent)
      break
    end
  end
end

local function create_tags_page(config, args)
  local files_by_tag = { untagged = {} }
  for _, file in pairs(list_note_files(config, { 'zet' })) do
    local fh = io.open(file.filepath, 'r')
    if fh then
      local tags = extract_tags(fh:read 'a')
      if #tags > 0 then
        for _, tag in pairs(tags) do
          if files_by_tag[tag] == nil then
            files_by_tag[tag] = {}
          end
          table.insert(files_by_tag[tag], file.filename)
        end
      else
        table.insert(files_by_tag['untagged'], file.filename)
      end
    end
    fh:close()
  end

  local tags = {}
  for tag, _ in pairs(files_by_tag) do
    table.insert(tags, tag)
  end
  table.sort(tags, function(a, b)
    if #files_by_tag[a] > #files_by_tag[b] then
      return true
    else
      return false
    end
  end)

  local content = {}
  for idx, tag in pairs(tags) do
    if idx ~= 1 then
      table.insert(content, '')
    end
    table.insert(content, '# ' .. tag .. ' (' .. #files_by_tag[tag] .. ')')
    for _, filename in pairs(files_by_tag[tag]) do
      table.insert(content, filename)
    end
  end

  vim.cmd 'enew'
  vim.b.notes_lsp_enable = true
  vim.bo.filetype = 'markdown'
  vim.api.nvim_buf_set_text(vim.fn.bufnr(), 0, 0, 0, 0, content)
  vim.o.modified = false
end

vim.api.nvim_create_user_command('Nn', function(opts)
  if #opts.fargs < 1 then
    return
  end

  local data = load_config()

  if opts.fargs[1] == 'tags' then
    create_tags_page(data, opts.fargs)
  else
    create_note(data, opts.fargs)
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

local lsp_helper = require 'lsp_helper'
lsp_helper.register_in_process_lsp('notes', {
  filetypes = { 'markdown' },
  root_dir = function(_, on_dir)
    -- Only enable the LSP if we're in a notes directory or have an option
    -- set to enable it. And share a single instance.
    if vim.b.notes_lsp_enable then
      on_dir(vim.fs.dirname(vim.g.NotesConfig))
    end

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
      for _, match in ipairs(find_links(line)) do
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
