-- C-m [1-9] will save the current buffer to a bookmark. C-[1-9] restores it. C-0 jumps back to the last buffer that was open before you started using C-[1-9]
local bookmarks = {}
local last_buffer_jumped_to = nil
local first_buffer_jumped_from = nil
local function swap_buffer(num)
  if bookmarks[num] then
    local curr_buffer = vim.fn.bufnr()
    if curr_buffer ~= last_buffer_jumped_to then
      first_buffer_jumped_from = curr_buffer
    end

    vim.cmd.buffer(bookmarks[num])
    last_buffer_jumped_to = bookmarks[num]
  end
end

local function swap_buffer_to_pre_jump()
  if first_buffer_jumped_from then
    vim.cmd.buffer(first_buffer_jumped_from)
  end
end

local function set_buffer(num)
  bookmarks[num] = vim.fn.bufnr()
end

vim.keymap.set('n', '<C-0>', swap_buffer_to_pre_jump)

for i = 1, 9 do
  vim.keymap.set('n', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('i', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('v', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('n', '<C-t>' .. i, function()
    set_buffer(i)
  end)
end
