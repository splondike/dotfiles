return {
  { -- Quick movements
    'ggandor/leap.nvim',
    config = function()
      require('leap').opts.safe_labels = 'fwhmq/;jgqzxcv'
      vim.keymap.set('n', 'p', '<plug>(leap-forward-to)', {silent=true})
      vim.keymap.set('n', 'P', '<plug>(leap-backward-to)', {silent=true})
    end
  }
}
