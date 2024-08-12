return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        keys = { 'f', 'F' },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "p", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "P", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
