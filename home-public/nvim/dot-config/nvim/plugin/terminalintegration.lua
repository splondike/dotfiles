local utils = require 'utils'

local function send_text(bufnr, pos1, pos2, linewise)
  if vim.g.SendToTerminalCommand == nil then
    return
  end

  local lines = utils.get_lines(pos1, pos2, bufnr).lines
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
