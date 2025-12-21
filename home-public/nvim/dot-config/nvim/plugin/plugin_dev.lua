-- Helpers for doing Neovim plugin development
-- For retesting some functionality, just record a macro and re-run that
-- To pretty print a value use `vim.print(value)`

function completions(arglead, cmdline, cursorpos)
  return { 'load', 'unload' }
end

function refresh_file()
  if vim.g.buffernumbers_bookmarks then
    local filename = vim.api.nvim_buf_get_name(vim.g.buffernumbers_bookmarks[1])
    vim.cmd('source ' .. filename)
  end
end

local original_messagesopt = nil
vim.api.nvim_create_user_command('Dev', function(opts)
  pcall(vim.keymap.del, 'n', '<localleader>t')

  if opts.args == 'load' then
    vim.keymap.set('n', '<localleader>t', refresh_file)
    original_messagesopt = vim.opt.messagesopt
    vim.opt.messagesopt = 'hit-enter,history:500'
  else
    if original_messagesopt ~= nil then
      vim.opt.messagesopt = original_messagesopt
    end
  end
end, { nargs = 1, complete = completions })
