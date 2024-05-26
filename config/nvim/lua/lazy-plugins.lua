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
  require 'thirdparty/plugins/leap',
  require 'thirdparty/plugins/nvim-treesitter-context',
  require 'thirdparty/plugins/oil',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- require 'thirdparty.plugins.debug',

  -- Language plugins
  require 'thirdparty.plugins.todo-txt-vim',
}

-- vim: ts=2 sts=2 sw=2 et
