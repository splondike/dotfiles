local toggle_time = function()
  local prefix = ' tracking:'
  local line = vim.fn.getline '.'
  local timestamp = os.date '%Y%m%d%H%M%S'
  local startidx = string.find(line, prefix, 1, true)

  if startidx then
    local offsetidx = startidx + string.len(prefix)
    local spaceidx = string.find(line, ' ', offsetidx, true)
    if not spaceidx then
      spaceidx = string.len(line)
    end
    local starttime = string.sub(line, offsetidx, spaceidx)
    local newline = string.sub(line, 1, startidx - 1)
    vim.fn.setline(vim.fn.line '.', newline)

    if vim.g.TodoTxtTimeTrackingTimeLogFile then
      local filename = vim.g.TodoTxtTimeTrackingTimeLogFile
      local csv_line = starttime .. ',' .. timestamp .. ',' .. newline
      local fh = io.open(filename, 'a')
      if fh then
        fh:write(csv_line .. '\n')
        fh:close()
      else
        error "Couldn't open file"
      end
    end
  else
    local newline = line .. prefix .. timestamp
    vim.fn.setline(vim.fn.line '.', newline)
  end
end

local open_toggle_file = function()
  if vim.g.TodoTxtTimeTrackingTimeLogFile then
    vim.cmd.e(vim.g.TodoTxtTimeTrackingTimeLogFile)
  end
end

local add_estimate = function()
  if vim.g.TodoTxtTimeTrackingTimeEstimatesFile then
    local line = vim.fn.getline '.'
    local timestamp = os.date '%Y%m%d%H%M%S'
    vim.cmd.e(vim.g.TodoTxtTimeTrackingTimeEstimatesFile)
    vim.cmd.normal 'Go'
    vim.fn.setline(vim.fn.line '.', ',' .. timestamp .. ',' .. line)
  end
end

-- Settings example:
-- vim.g.TodoTxtTimeTrackingTimeEstimatesFile = os.getenv 'HOME' .. '/Documents/estimates.csv'
-- vim.g.TodoTxtTimeTrackingTimeLogFile = os.getenv 'HOME' .. '/Documents/timetracking.csv'
vim.keymap.set('n', '<localleader>t', toggle_time, { buffer = true })
vim.keymap.set('n', '<localleader>o', open_toggle_file, { buffer = true })
vim.keymap.set('n', '<localleader>e', add_estimate, { buffer = true })
