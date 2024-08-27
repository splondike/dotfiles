vim.wo.foldmethod = 'marker'

local add_entry = function()
  local num_lines = vim.api.nvim_buf_line_count(0)
  for line_id = num_lines, 1, -1 do
    local line = vim.fn.getline(line_id)
    if string.find(line, 'insert-pos', 1, true) ~= nil then
      -- This toggle to insert mode via 'regular' means seems to be necessary
      -- for the later expand_or_jump to work.
      vim.cmd.normal 's'
      vim.api.nvim_buf_set_text(0, line_id - 1, 0, line_id, 0, { '', 'cash', line, '' })
      vim.cmd.startinsert()
      vim.fn.cursor(line_id + 1, 5)
      require('luasnip').expand_or_jump()
      break
    end
  end
end

vim.keymap.set('n', '<localleader>a', add_entry, { buffer = true })
