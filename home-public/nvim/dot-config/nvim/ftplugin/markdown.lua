vim.wo.foldmethod = 'marker'
vim.bo.completeopt = 'menu,popup,noselect'

local function spell_check()
  vim.wo.spell = true
  vim.cmd.normal ']si'
  vim.cmd.startinsert()
  local key = vim.api.nvim_replace_termcodes('<C-x><C-s>', true, true, true)
  vim.api.nvim_feedkeys(key, 'i', false)
end

local function wrap_link()
  local old_reg = vim.fn.getreg 'z'
  vim.cmd 'normal "zr'
  local highlighted_text = vim.fn.getreg 'z'
  vim.api.nvim_put({ '[' }, 'c', false, true)
  vim.api.nvim_put({ highlighted_text }, 'c', false, true)
  vim.api.nvim_put({ '](' }, 'c', false, true)
  vim.api.nvim_put({ ')' }, 'c', false, false)
  vim.fn.setreg('z', old_reg)
  vim.cmd.startinsert()
  vim.schedule(function()
    vim.lsp.buf.completion()
  end)
end

-- The path and buffer sources clog up the list for my notes lsp, so just turn them off.
require('cmp').setup.filetype('markdown', {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

vim.keymap.set('n', '<C-b>', spell_check, { buffer = true })
vim.keymap.set('i', '<C-b>', spell_check, { buffer = true })
vim.keymap.set('v', '<localleader>l', wrap_link, { buffer = true })
