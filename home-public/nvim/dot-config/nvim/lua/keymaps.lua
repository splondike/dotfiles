-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

------- Misc

-- Use h instead of z for folds
vim.keymap.set('', 'h', 'z')
-- Toggle recent buffers
vim.keymap.set('n', '<Leader>s', '<C-^>')
-- Edit relative to current buffer
vim.keymap.set('c', 'e;', '"e " . expand("%:h") . "/"', { expr = true })
-- Open spell check (easier than h= in Termux)
vim.keymap.set('n', 'jj', 'z=')

------- Mode switching

vim.keymap.set('n', ';', ':')

vim.keymap.set('n', 's', 'i')
vim.keymap.set('n', 'S', 'I')
vim.keymap.set('n', 't', 'a')
vim.keymap.set('n', 'T', 'A')
vim.keymap.set('n', 'a', 'v')
vim.keymap.set('n', 'A', 'V')
vim.keymap.set('', 'r', 'c')

------- Jumps

vim.keymap.set('n', ')', '<C-i>')
vim.keymap.set('n', '(', '<C-o>')

------- Editing things

vim.keymap.set('n', '<C-k>', ':move .-2<CR>', { silent = true })
vim.keymap.set('n', '<C-m>', ':move .+1<CR>', { silent = true })
vim.keymap.set('v', '<C-k>', ":move '<-2<CR>gv", { silent = true })
vim.keymap.set('v', '<C-m>', ":move '>+1<CR>gv", { silent = true })

------- Undo/Redo/Copy+Paste

vim.keymap.set('n', 'z', 'u')
vim.keymap.set('n', 'Z', '<C-r>')

vim.keymap.set('', 'c', 'y')
vim.keymap.set('', 'v', 'gP')
vim.keymap.set('', 'C', 'yy')
vim.keymap.set('', 'V', 'p')

------- Movement

vim.keymap.set('', 'n', 'h')
vim.keymap.set('', 'u', 'k')
vim.keymap.set('', 'e', 'j')
vim.keymap.set('', 'i', 'l')

vim.keymap.set('', 'N', '5h')
vim.keymap.set('', 'U', '5k')
vim.keymap.set('', 'E', '5j')
vim.keymap.set('', 'I', '5l')
vim.keymap.set('', '<C-u>', '5k')
vim.keymap.set('', '<C-e>', '5j')

vim.keymap.set('', 'l', 'b')
vim.keymap.set('', 'y', 'w')
vim.keymap.set('', 'L', '^')
vim.keymap.set('', 'Y', '^')
vim.keymap.set('', '<C-l>', '^')
vim.keymap.set('', '<C-y>', '$')

vim.keymap.set('n', ']t', '<cmd>cnext<cr>')
vim.keymap.set('n', '[t', '<cmd>cprev<cr>')

------- Windows

vim.keymap.set('n', '<C-w>n', '<C-w>h')
vim.keymap.set('n', '<C-w>u', '<C-w>k')
vim.keymap.set('n', '<C-w>e', '<C-w>j')
vim.keymap.set('n', '<C-w>i', '<C-w>l')

------- Search

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-i>', 'n')
vim.keymap.set('n', '<C-o>', 'N')

------- Text objects

-- Remap some built in text objects
for _, textObject in pairs { 'w', 'W', 's', 'p' } do
  -- Make new text objects
  vim.keymap.set('x', 's' .. textObject, 'i' .. textObject)
  vim.keymap.set('o', 's' .. textObject, 'i' .. textObject)
  vim.keymap.set('x', 't' .. textObject, 'a' .. textObject)
  vim.keymap.set('o', 't' .. textObject, 'a' .. textObject)

  -- Remove originals
  vim.keymap.set('x', 'i' .. textObject, '')
  vim.keymap.set('o', 'i' .. textObject, '')
  vim.keymap.set('x', 'a' .. textObject, '')
  vim.keymap.set('o', 'a' .. textObject, '')
end

-- vim: ts=2 sts=2 sw=2 et
