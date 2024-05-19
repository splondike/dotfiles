-- base64 encode selected
vim.keymap.set('v', '<leader>64', 'c<c-r>=trim(system(\'base64\', @"))<cr><esc>"')
-- base64 dencode selected
vim.keymap.set('v', '<leader>46', 'c<c-r>=system(\'base64 --decode\', @")<cr><esc>"')
