function build_filename(note_type, args)
  local short_type = note_type.name:sub(1, 3)
  local timestr = (os.date '%Y%m%d%H%M'):sub(3)
  local title_table = {}
  for i = 1, #args do
    title_table[i] = string.lower(args[i]):gsub('[^a-zA-Z0-9]', '')
  end
  return timestr .. '-' .. short_type .. '-' .. table.concat(title_table, '-') .. '.md'
end

function build_file_content(note_type, args, current_filepath)
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

function tbl_concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

function load_config()
  local config_files = { vim.g.NotesConfig }
  local rtn = { note_types = {} }
  while #config_files > 0 do
    local config_file = config_files[1]
    table.remove(config_files, 1)
    local fh = io.open(config_file, 'r')
    if not fh then
      return
    end
    local data = vim.fn.json_decode(vim.trim(fh:read 'a'))
    rtn['note_types'] = tbl_concat(rtn['note_types'], data['note_types'])
    config_files = tbl_concat(config_files, data['includes'])
    fh:close()
  end
  return rtn
end

function completions(arglead, cmdline, cursorpos)
  if arglead:find(' ', 1, true) ~= nil then
    -- No autocomplete beyond the type
    return {}
  end

  local data = load_config()
  local rtn = {}
  for _, note_type in ipairs(data.note_types) do
    table.insert(rtn, note_type.name)
  end
  return rtn
end

vim.api.nvim_create_user_command('NoteCreate', function(opts)
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
end, { nargs = '+', complete = completions })
