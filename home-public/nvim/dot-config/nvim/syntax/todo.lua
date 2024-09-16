-- Early exit the highlighting rules from the plugin's syntax highlighter, I can't work out how to clear it after the fact
vim.b.current_syntax = 'todo-custom'

vim.cmd.syntax "match TodoTrackingTime 'tracking:\\d\\+'"
vim.cmd.highlight 'TodoTrackingTime ctermfg=01'
vim.cmd.syntax "match TodoDue 'due:\\d\\{4\\}-\\d\\{2\\}-\\d\\{2\\}'"
vim.cmd.highlight 'TodoDue ctermfg=03'
vim.cmd.syntax "match TodoProject ' @[a-z-]\\+'"
vim.cmd.highlight 'TodoProject ctermfg=06'
vim.cmd.syntax "match TodoDone '^x .\\+'"
vim.cmd.highlight 'TodoDone ctermfg=08'
