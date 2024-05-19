-- The todo.txt-vim syntax highlighting only allows certain match groups
-- within it. So I just piggy back on one of those.
vim.cmd.syntax('match OverDueDate \'tracking:\\d\\+\'')
vim.cmd.highlight('default link OverDueDate Character')

vim.cmd.highlight('link TodoPriorityA Normal')
vim.cmd.highlight('link TodoPriorityB Normal')
vim.cmd.highlight('link TodoPriorityC Normal')
