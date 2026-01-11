local function send_text(bufnr, pos1, pos2, linewise)
  if vim.g.SendToTerminalCommand == nil then
    return
  end

  if pos1 == '.' or pos2 == '.' then
    bufnr = vim.fn.bufnr()
  end

  local function getposition(pos, atstart)
    if pos == '.' then
      local bits = vim.fn.getpos '.'
      return { bits[2], bits[3] }
    elseif pos == 'v' then
      local bits = vim.fn.getpos 'v'
      return { bits[2], bits[3] }
    elseif pos == '$' then
      return { vim.api.nvim_buf_line_count(bufnr), vim.v.maxcol }
    elseif string.sub(pos, 1, 1) == "'" then
      return vim.api.nvim_buf_get_mark(bufnr, string.sub(pos, 2, 2))
    else
      local col = vim.v.maxcol
      if atstart then
        col = 0
      end
      return { tonumber(pos), col }
    end
  end

  local lines = {}
  local pos1_bits = getposition(pos1, true)
  local line1 = pos1_bits[1]
  local col1 = pos1_bits[2]
  local pos2_bits = getposition(pos2, false)
  local line2 = pos2_bits[1]
  local col2 = pos2_bits[2]
  if line1 > line2 then
    local templine = line1
    local tempcol = col1
    line1 = line2
    col1 = col2
    line2 = templine
    col2 = tempcol
  end

  lines = vim.api.nvim_buf_get_lines(bufnr, line1 - 1, line2, false)
  vim.system(vim.g.SendToTerminalCommand, { stdin = lines })
end

local function cmd_send_hovered_text()
  local mode = vim.fn.mode()
  if mode == 'n' then
    if vim.g.termint_range ~= nil then
      send_text(vim.g.termint_range[1], vim.g.termint_range[2], vim.g.termint_range[3], true)
    else
      send_text(vim.fn.bufnr(), '.', '.', true)
    end
  elseif mode == 'V' then
    send_text(vim.fn.bufnr(), '.', 'v', true)
  end
end

local function cmd_send_set_marks(args)
  if #args == 1 then
    vim.g.termint_range = nil
  else
    vim.g.termint_range = { vim.fn.bufnr(), args[2], args[3] }
  end
end

local commands = {
  ['send-set-marks'] = { cmd_send_set_marks, { { '1 $', '. .', "'z 'x" } } },
}

local function cmd_completions(_, cmd, cursor)
  if string.sub(cmd, cursor, cursor) ~= ' ' then
    return {}
  end
  local prefix = vim.trim(string.sub(cmd, 1, cursor))
  local bits = vim.split(prefix, ' ')
  if #bits == 1 then
    local rtn = {}
    for name, _ in pairs(commands) do
      table.insert(rtn, name)
    end
    return rtn
  else
    return commands[bits[2]][2][#bits - 1]
  end
end

vim.api.nvim_create_user_command('TermInt', function(opts)
  if #opts.fargs < 1 then
    return
  end

  for name, info in pairs(commands) do
    if opts.fargs[1] == name then
      info[1](opts.fargs)
    end
  end
end, { nargs = '+', complete = cmd_completions })

vim.keymap.set({ 'n', 'v' }, '<leader>n', cmd_send_hovered_text, { silent = true })
