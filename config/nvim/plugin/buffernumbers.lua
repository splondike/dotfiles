local bookmarks = {}
local swap_buffer = function(num)
  if bookmarks[num] then
    vim.cmd.buffer(bookmarks[num])
  end
end

local set_buffer = function(num)
  bookmarks[num] = vim.fn.bufnr()
end

for i = 1, 5 do
  vim.keymap.set('n', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('i', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('v', '<C-' .. i .. '>', function()
    swap_buffer(i)
  end)
  vim.keymap.set('n', '<C-m>' .. i, function()
    set_buffer(i)
  end)
end
