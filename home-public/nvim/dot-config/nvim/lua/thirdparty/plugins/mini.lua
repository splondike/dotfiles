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
      local overrides = {
        { 'Keyword', 13, 'NONE' },
        { 'Visual', 0, 20 },
        { 'DiffAdd', 'NONE', 2 },
        { 'DiffChange', 'NONE', 2 },
        { 'DiffText', 2, 5 },
      }
      for _, item in pairs(overrides) do
        vim.cmd(string.format('highlight %s ctermfg=%s ctermbg=%s gui=NONE cterm=NONE guisp=NONE', item[1], item[2], item[3]))
      end

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
