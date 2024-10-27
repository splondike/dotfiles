vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { 'bookkeeping.txt' },
  callback = function()
    vim.bo.filetype = 'bookkeeping'
  end,
})
