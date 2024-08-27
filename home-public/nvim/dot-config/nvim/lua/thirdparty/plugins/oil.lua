return {
  { -- Better file system browser
    'stevearc/oil.nvim',
    opts = {},
    keys = {
      {
        '<leader>o',
        ':Oil<CR>',
        mode = 'n',
        desc = 'Show file browser',
      },
    },
  },
}
