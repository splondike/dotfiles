local function find_extent(line, col)
  -- Find the start and end of the subword
  local function ct(pos)
    local c = line:sub(pos, pos)
    if c:match '[A-Z]' then
      return 'u'
    elseif c:match '[a-z]' then
      return 'l'
    else
      return 'o'
    end
  end
  local start_pos, end_pos = col, col
  local state_start = ct(col)
  local state_end = state_start

  if state_start == 'o' then
    return start_pos, end_pos
  end

  -- Keep going to the left until we reach the end of the uppercase letters
  while start_pos > 1 do
    local state_curr = ct(start_pos)
    if state_start == 'u' then
      if state_curr ~= 'u' then
        start_pos = start_pos + 1
        break
      end
    elseif state_start == 'l' then
      if state_curr == 'u' then
        state_start = 'u'
      elseif state_curr == 'o' then
        start_pos = start_pos + 1
        break
      end
    end
    start_pos = start_pos - 1
  end

  -- Keep going to the right until we reach the end of the lowercase letters
  while end_pos < line:len() do
    local state_curr = ct(end_pos)
    if state_end == 'u' then
      if state_curr == 'l' then
        state_end = 'l'
      elseif state_curr == 'o' then
        end_pos = end_pos - 1
        break
      end
    elseif state_end == 'l' then
      if state_curr ~= 'l' then
        end_pos = end_pos - 1
        break
      end
    end
    end_pos = end_pos + 1
  end

  return start_pos, end_pos
end

local function isVisualMode()
  return vim.fn.mode():find 'v' ~= nil
end

local function select_subword()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  -- Make the column 1 indexed
  local col = pos[2] + 1

  local start_pos, end_pos = find_extent(line, col)

  vim.api.nvim_win_set_cursor(0, { pos[1], start_pos - 1 })
  if isVisualMode() then
    vim.cmd 'normal! o'
  else
    vim.cmd 'normal! v'
  end
  vim.api.nvim_win_set_cursor(0, { pos[1], end_pos - 1 })
end

-- WhatIsThisThing

if vim then
  vim.keymap.set('o', 'c', select_subword)
  -- Using this 'x' map interferes with the copy command in visual mode
  -- vim.keymap.set('x', 'c', select_subword)
else
  return {
    find_extent = find_extent,
  }
end
