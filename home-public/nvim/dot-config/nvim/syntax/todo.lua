-- Stop some things from being highlighted
vim.cmd.highlight 'clear TodoPriorityA'
vim.cmd.highlight 'clear TodoPriorityB'
vim.cmd.highlight 'clear TodoPriorityC'

-- Make the tracking text red
vim.cmd.syntax "match TodoTrackingTime 'tracking:\\d\\+'"
vim.cmd.highlight 'TodoTrackingTime ctermfg=01'
