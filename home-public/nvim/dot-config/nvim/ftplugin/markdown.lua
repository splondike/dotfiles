vim.wo.foldmethod = 'marker'
vim.bo.completeopt = 'menu,popup,noselect'

local spell_check = function()
  vim.wo.spell = true
  vim.cmd.normal ']si'
  vim.cmd.startinsert()
  local key = vim.api.nvim_replace_termcodes('<C-x><C-s>', true, true, true)
  vim.api.nvim_feedkeys(key, 'i', false)
end

vim.keymap.set('n', '<C-b>', spell_check, { buffer = true })
vim.keymap.set('i', '<C-b>', spell_check, { buffer = true })
