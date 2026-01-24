-- Utility functions for my plugins
local M = {}

function M.call_process(cmd, args, input, timeout, callback)
  local stdin = vim.uv.new_pipe()
  local stdout = vim.uv.new_pipe()
  local stderr = vim.uv.new_pipe()
  local stdout_data = ''
  local stderr_data = ''
  local cmd_status = 'running'
  local callback_ = vim.schedule_wrap(callback)
  local handle, _ = vim.uv.spawn(cmd, { args = args, stdio = { stdin, stdout, stderr } }, function(code, _)
    if cmd_status == 'timeout' then
      callback_(false, 'Command timed out')
    elseif code == 0 then
      cmd_status = 'finished'
      callback_(true, stdout_data)
    else
      cmd_status = 'errored'
      callback_(false, 'Error calling process: stdout=' .. stdout_data .. ' stderr=' .. stderr_data)
    end
  end)
  vim.uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data ~= nil then
      stdout_data = stdout_data .. data
    end
  end)
  vim.uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data ~= nil then
      stderr_data = stderr_data .. data
    end
  end)
  vim.uv.write(stdin, input)
  vim.uv.shutdown(stdin)

  vim.defer_fn(function()
    if cmd_status == 'running' then
      cmd_status = 'timeout'
      vim.uv.process_kill(handle, vim.loop.constants.SIGKILL)
    end
  end, timeout)
end

function M.get_lines(pos1, pos2, bufnr)
  if pos1 == '.' or pos2 == '.' or bufnr == nil then
    bufnr = vim.fn.bufnr()
  end

  local function getposition(pos, atstart)
    if pos == '.' then
      local bits = vim.fn.getpos '.'
      return { bits[2], bits[3] }
    elseif pos == 'v' then
      local bits = vim.fn.getpos 'v'
      return { bits[2], bits[3] }
    elseif pos == '$' then
      return { vim.api.nvim_buf_line_count(bufnr), vim.v.maxcol }
    elseif string.sub(pos, 1, 1) == "'" then
      return vim.api.nvim_buf_get_mark(bufnr, string.sub(pos, 2, 2))
    else
      local col = vim.v.maxcol
      if atstart then
        col = 0
      end
      return { tonumber(pos), col }
    end
  end

  local lines = {}
  local pos1_bits = getposition(pos1, true)
  local line1 = pos1_bits[1]
  local col1 = pos1_bits[2]
  local pos2_bits = getposition(pos2, false)
  local line2 = pos2_bits[1]
  local col2 = pos2_bits[2]
  if line1 > line2 then
    local templine = line1
    local tempcol = col1
    line1 = line2
    col1 = col2
    line2 = templine
    col2 = tempcol
  end
  lines = vim.api.nvim_buf_get_lines(bufnr, line1 - 1, line2, false)
  return {
    lines = lines,
    start_line = line1,
    end_line = line2,
  }
end

return M
