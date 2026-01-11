-- Load up a custom homescreen on load

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = { '*' },
  desc = 'Load a default file',
  group = vim.api.nvim_create_augroup('custom_homescreen', { clear = true }),
  callback = function()
    local current_filepath = vim.api.nvim_buf_get_name(vim.fn.bufnr())
    if current_filepath ~= '' then
      -- User has explicitly loaded something, don't override that
      return
    end
    local homepages = { 'index.md', 'index.gitignored.md' }
    for _, homepage in ipairs(homepages) do
      local fh = io.open(homepage, 'r')
      if fh then
        fh:close()
        -- nofile+noswapfile seems to be the easiest way of letting
        -- the file be opened more than once without warnings
        vim.o.buftype = 'nofile'
        vim.cmd('edit ' .. homepage)
        vim.cmd 'setlocal noswapfile'
        vim.cmd 'set ft=markdown'
      end
    end
  end,
})
