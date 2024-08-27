local toggle_gutter = function()
  if vim.o.number == true then
    vim.opt.number = false
    vim.opt.signcolumn = 'no'
  else
    vim.opt.number = true
    vim.opt.signcolumn = 'yes'
  end
end

vim.keymap.set('n', '<leader>l', toggle_gutter)
