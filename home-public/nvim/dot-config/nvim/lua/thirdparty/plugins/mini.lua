return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Theme (base16 tomorrow night)
      -- See semantics of the numbering scheme here https://github.com/chriskempson/base16/blob/main/styling.md
      -- Force mini16 to use the cterm_palette
      vim.opt.termguicolors = false
      local cterm_palette = {
        -- Pure background progressing through to highlight
        base00 = 00,
        base01 = 19,
        base02 = 59,
        base03 = 08,
        base04 = 20,
        base05 = 07,
        base06 = 21,
        base07 = 15,

        -- Accent colors
        -- base08 = 01,
        base08 = 07,
        base09 = 136,
        base0A = 03,
        base0B = 02,
        base0C = 06,
        base0D = 04,
        base0E = 103,
        base0F = 67,
        -- Monochrome experiment
        -- base08 = 07,
        -- base09 = 07,
        -- base0A = 07,
        -- base0C = 07,
        -- base0B = 07,
        -- base0D = 07,
        -- base0E = 07,
        -- base0F = 07,
      }
      -- I don't use the gui stuff (setnotermguicolors), so it's some random colours
      local gui_palette = {
        base00 = '#1d1f21',
        base01 = '#cc6667',
        base02 = '#b5bd68',
        base03 = '#f0c674',
        base04 = '#81a2be',
        base05 = '#b294bb',
        base06 = '#8abeb7',
        base07 = '#c5c8c6',
        base08 = '#969896',
        base09 = '#cc6666',
        base0A = '#b5bd68',
        base0B = '#f0c674',
        base0C = '#81a2be',
        base0D = '#b294bb',
        base0E = '#8abeb7',
        base0F = '#ffffff',
      }
      require('mini.base16').setup {
        use_cterm = cterm_palette,
        palette = gui_palette,
      }
      -- Don't have the line number/sign column filled in
      local gutter_groups = { 'SignColumn', 'LineNr', 'GitSignsAdd', 'GitSignsChange', 'GitSignsChange', 'GitSignsDelete', 'GitSignsUntracked' }
      for _, group in pairs(gutter_groups) do
        vim.cmd(
          string.format(
            'highlight %s guifg=%s ctermfg=%s guibg=%s ctermbg=%s gui=%s cterm=%s guisp=%s',
            group,
            gui_palette.base03,
            cterm_palette.base03,
            gui_palette.base00,
            cterm_palette.base00,
            'NONE',
            'NONE',
            'NONE'
          )
        )
      end
      -- Can use cterm=bold,underline,underdouble too
      local overrides = {
        { 'Keyword', 13, 'NONE' },
        { 'Visual', 0, 20 },
        { 'DiffAdd', 15, 19 }, --Added text
        { 'DiffText', 15, 19 }, -- Modified part of a line
        { 'DiffChange', 'NONE', 'NONE' }, -- The unmodified part of the line
        { 'DiffDelete', 0, 103 },
        { 'MiniPickMatchCurrent', 0, 20 },
        { 'MiniFilesCursorLine', 'NONE', 19 },
      }
      for _, item in pairs(overrides) do
        vim.cmd(string.format('highlight %s ctermfg=%s ctermbg=%s gui=NONE cterm=NONE guisp=NONE', item[1], item[2], item[3]))
      end

      -- File browser
      require('mini.files').setup {
        mappings = {
          go_in = '<CR>',
          go_out = '-',
        },
        windows = {
          max_number = 1,
          width_focus = 1000,
        },
      }
      vim.keymap.set('n', '<leader>o', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { desc = '[O]pen file browser' })

      -- Fuzzy item picker, see also lspconfig
      require('mini.pick').setup {
        mappings = {
          delete_left = '',
          move_up = '<C-u>',
          move_down = '<C-e>',
        },
        -- source = {
        --   show = MiniPick.pick.default_show,
        -- },
        window = {
          config = function()
            local height = math.min(math.floor(vim.o.lines), 30)
            local width = math.min(math.floor(vim.o.columns), 100)

            return {
              anchor = 'NW',
              height = height,
              width = width,
              row = math.floor(0.5 * (vim.o.lines - height)),
              col = math.floor(0.5 * (vim.o.columns - width)),
            }
          end,
        },
      }
      local truncate_filepath = function(filepath, max_width)
        local rtn = filepath
        local last_slash_idx = vim.fn.strridx(rtn, '/')
        if last_slash_idx > -1 then
          -- strridx is 0 indexed
          rtn = rtn:sub(last_slash_idx + 2)
        end
        if #rtn > max_width then
          return rtn:sub(1, max_width - 1) .. '…'
        else
          return rtn
        end
      end
      local show_func = function(f)
        return function(buf_id, items_arr, query)
          local items = vim.tbl_map(f, items_arr)
          MiniPick.default_show(buf_id, items, query)
        end
      end

      vim.keymap.set('n', '<leader>th', MiniPick.builtin.help, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>tf', MiniPick.builtin.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ttf', function()
        MiniPick.builtin.files(nil, {
          source = {
            cwd = vim.fn.expand '%:p:h',
          },
        })
      end, { desc = '[S]earch [F]iles in current buffer dir' })
      vim.keymap.set('n', '<leader>tg', MiniPick.builtin.grep_live, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>ttg', function()
        MiniPick.builtin.grep_live(nil, {
          source = {
            cwd = vim.fn.expand '%:p:h',
          },
        })
      end, { desc = '[S]earch by [G]rep in current buffer dir' })
      vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>ts', MiniPick.builtin.resume, { desc = '[S]earch Re[s]ume' })
      vim.keymap.set('n', '<leader>tnf', function()
        MiniPick.builtin.files(nil, {
          source = {
            cwd = vim.g.TelescopeNotesDir,
            name = 'Files notes',
            show = show_func(function(x)
              return truncate_filepath(x, vim.o.columns + 1)
            end),
          },
        })
      end, { desc = 'Search [n]otes [f]iles' })
      vim.keymap.set('n', '<leader>tng', function()
        MiniPick.builtin.grep_live(nil, {
          source = {
            cwd = vim.g.TelescopeNotesDir,
            name = 'Grep notes',
            show = show_func(function(x)
              local path_end_idx, _ = string.find(x, '\000')
              local path = x:sub(1, path_end_idx - 1)
              local content = x:sub(string.find(x, '\000', string.find(x, '\000', path_end_idx + 1) + 1) + 1)
              local filepath = truncate_filepath(path, math.max(math.floor(0.5 * vim.o.columns), 50))

              return filepath .. '\000' .. content
            end),
          },
        })
      end, { desc = 'Search [n]otes [g]rep' })
      vim.keymap.set('n', '<leader>trf', function()
        MiniPick.builtin.files(nil, {
          source = {
            cwd = vim.g.TelescopeReposRootDir,
            name = 'Files repos',
          },
        })
      end, { desc = 'Search [r]epos [f]iles' })
      vim.keymap.set('n', '<leader>trg', function()
        MiniPick.builtin.grep_live(nil, {
          source = {
            cwd = vim.g.TelescopeReposRootDir,
            name = 'Grep repos',
          },
        })
      end, { desc = 'Search [r]epos [g]rep' })

      -- Better Around/Inside textobjects
      require('mini.ai').setup {
        n_lines = 500,
        mappings = { around = 't', inside = 's' },
      }

      -- Commenting
      require('mini.comment').setup {
        mappings = {
          comment = '<leader>c',
          comment_line = '<leader>cc',
          comment_visual = '<leader>c',
        },
      }

      -- Reformat
      require('mini.splitjoin').setup {
        mappings = {
          toggle = '<leader>m',
        },
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
