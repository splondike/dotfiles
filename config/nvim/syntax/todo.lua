-- Make the tracking text red
vim.cmd.syntax "match TodoTrackingTime 'tracking:\\d\\+'"
vim.cmd.highlight 'TodoTrackingTime ctermfg=01'

-- Stop some things from being highlighted
vim.cmd.highlight 'link TodoPriorityA Normal'
vim.cmd.highlight 'link TodoPriorityB Normal'
vim.cmd.highlight 'link TodoPriorityC Normal'
