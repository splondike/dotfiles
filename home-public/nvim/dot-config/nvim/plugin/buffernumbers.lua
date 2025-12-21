-- C-T [neio] will save the current buffer to a bookmark. C-t [neio] restores it. C-t h jumps back to the last buffer that was open before you started using C-t [neio]
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
  vim.g.buffernumbers_bookmarks = bookmarks
end

vim.keymap.set('n', '<C-t>h', swap_buffer_to_pre_jump)

for i, key in ipairs { 'n', 'e', 'i', 'o' } do
  local binding = '<leader>s' .. key
  vim.keymap.set('n', binding, function()
    swap_buffer(i)
  end)
  vim.keymap.set('i', binding, function()
    swap_buffer(i)
  end)
  vim.keymap.set('v', binding, function()
    swap_buffer(i)
  end)
  vim.keymap.set('n', '<leader>S' .. key, function()
    set_buffer(i)
  end)
end
