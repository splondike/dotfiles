-- Adds a vim command that copies a URL to the current file and line number to the clipboard

local function starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local function ends_with(str, suffix)
  return str:sub(#str - #suffix + 1, #str) == suffix
end

local function get_repo_url()
  local result = io.popen('git remote get-url origin', 'r')
  if result == nil then
    return
  end
  local url = result:lines()()
  if ends_with(url, '.git') then
    url = url:sub(1, #url - 4)
  end

  return url
end

local function get_relative_file_path(filename)
  local result = io.popen('git ls-files --full-name ' .. filename, 'r')
  if result == nil then
    return
  end
  return result:lines()()
end

vim.api.nvim_create_user_command('FoundryUrl', function()
  local url = get_repo_url()
  local buffer_filename = vim.fn.expand '%:p'
  local filename = get_relative_file_path(buffer_filename)
  local line_number = vim.fn.line '.'

  local glPrefix = 'https://gitlab.com'
  local ghPrefix = 'https://github.com'
  local final_url = ''
  if starts_with(url, glPrefix) then
    final_url = url .. '/-/blob/main/' .. filename .. '#L' .. line_number
  elseif starts_with(url, ghPrefix) then
    final_url = url .. '/blob/main/' .. filename .. '#L' .. line_number
  end

  if final_url ~= '' then
    vim.fn.setreg('+', final_url)
    print('Copied url: ' .. final_url)
  else
    print('Unknown remote: ' .. url)
  end
end, {})

-- local function reload()
--   vim.cmd 'source %'
--   vim.cmd 'FoundryUrl'
--   -- vim.cmd ':messages'
-- end
--
-- vim.keymap.del('n', '<localleader>t')
-- vim.keymap.set('n', '<localleader>t', reload)
