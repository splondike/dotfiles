-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  -- Generic plugins
  require 'thirdparty/plugins/mini',
  require 'thirdparty/plugins/telescope',
  require 'thirdparty/plugins/lspconfig',
  require 'thirdparty/plugins/cmp',
  require 'thirdparty/plugins/conform',
  require 'thirdparty/plugins/treesitter',
  require 'thirdparty/plugins/flash',
  require 'thirdparty/plugins/nvim-treesitter-context',
  require 'thirdparty/plugins/oil',
  require 'thirdparty/plugins/vimagit',
  require 'thirdparty/plugins/diffview',
  require 'thirdparty/plugins/csvview',
  'splondike/nvim-tui',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'Hoffs/omnisharp-extended-lsp.nvim',
  -- require 'thirdparty.plugins.debug',

  -- Language plugins
  require 'thirdparty.plugins.todo-txt-vim',
}

-- Built in plugin we need to enable
vim.cmd.packadd 'cfilter'

-- vim: ts=2 sts=2 sw=2 et
