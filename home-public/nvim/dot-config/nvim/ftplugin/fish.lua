local function save_quit()
  vim.cmd ':wq'
end

vim.keymap.set('', '<C-o>', save_quit, { buffer = true })
