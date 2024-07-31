local source_file = function()
  vim.cmd.source '%'
  vim.cmd.echo('"Sourced ' .. vim.fn.strftime '%H:%M:%S' .. '"')
end

vim.keymap.set('n', '<localleader>s', source_file, { buffer = true })
