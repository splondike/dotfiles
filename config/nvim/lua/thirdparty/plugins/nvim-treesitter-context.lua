return {
  { -- Show current function
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      max_lines = 3,
      multiline_threshold = 3,
    },
  },
}
