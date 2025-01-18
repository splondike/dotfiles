-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              -- height = 100,
              width = {
                0.99,
                max = 100,
              },
              preview_cutoff = 15,
              preview_height = 5,
            },
          },
          mappings = {
            i = {
              -- Turn off the default vim mode stuff, I don't
              -- find it useful
              ['<esc>'] = require('telescope.actions').close,
            },
          },
          file_ignore_patterns = {
            '.git/',
          },
          path_display = { 'truncate' },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          buffers = {
            sort_lastused = true,
          },
          lsp_references = {
            show_line = false,
          },
        },
        -- extensions = {
        --   ['ui-select'] = {
        --     require('telescope.themes').get_dropdown(),
        --   },
        -- },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ttf', function(opts)
        if not opts then
          opts = {}
        end
        opts.cwd = vim.fn.expand '%:p:h'
        opts.no_ignore = true
        builtin.live_grep(opts)
      end, { desc = '[S]earch [F]iles in current buffer dir' })
      vim.keymap.set('n', '<leader>tg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>ttg', function(opts)
        if not opts then
          opts = {}
        end
        opts.cwd = vim.fn.expand '%:p:h'
        opts.additional_args = { '--no-ignore' }
        builtin.live_grep(opts)
      end, { desc = '[S]earch by [G]rep in current buffer dir' })
      vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>ts', builtin.resume, { desc = '[S]earch Re[s]ume' })
      vim.keymap.set('n', '<leader>te', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>t/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>tnf', function(opts)
        if not opts then
          opts = {}
        end
        opts.prompt_title = 'Search notes by filename'
        opts.cwd = vim.g.TelescopeNotesDir
        builtin.find_files(opts)
      end, { desc = 'Search [n]otes [f]iles' })
      vim.keymap.set('n', '<leader>tng', function(opts)
        if not opts then
          opts = {}
        end
        opts.prompt_title = 'Search notes by grep'
        opts.cwd = vim.g.TelescopeNotesDir
        builtin.live_grep(opts)
      end, { desc = 'Search [n]otes [g]rep' })

      vim.keymap.set('n', '<leader>trf', function(opts)
        if not opts then
          opts = {}
        end
        opts.prompt_title = 'Search repos by filename'
        opts.cwd = vim.g.TelescopeReposRootDir
        builtin.find_files(opts)
      end, { desc = 'Search [r]epos [f]iles' })
      vim.keymap.set('n', '<leader>trg', function(opts)
        if not opts then
          opts = {}
        end
        opts.prompt_title = 'Search repos by grep'
        opts.cwd = vim.g.TelescopeReposRootDir
        builtin.live_grep(opts)
      end, { desc = 'Search [r]epos [g]rep' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
