return {
  'hat0uma/csvview.nvim',
  opts = {
    keymaps = {
      jump_next_field_end = { 'I', mode = { 'n', 'v' } },
      jump_prev_field_end = { 'N', mode = { 'n', 'v' } },
    },
  },
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
}
