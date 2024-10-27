local function add_entry()
  local buf = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  local timestamp = os.date '%d/%m/%Y'
  for line_number = line_count, 0, -1 do
    local line = vim.fn.getline(line_number)
    if string.match(line, '%d%d/%d%d/%d%d%d%d') then
      vim.cmd.normal 'Go'
      if line ~= timestamp then
        vim.api.nvim_put({ tostring(timestamp), '' }, 'l', true, true)
      end
      vim.cmd 'startinsert'
      break
    end
  end
end

vim.keymap.set('n', '<localleader>a', add_entry, { buffer = true })
