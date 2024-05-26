-- Oil does the wrong thing on Termux with /sdcard/ .
-- Monkey patch its check to override the behaviour for that dir
local file_mod = require 'oil.adapters.files'
if not file_mod._is_modifiable_monkeypatched then
  local util = require 'oil.util'
  local orig = file_mod.is_modifiable
  file_mod.is_modifiable = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local _, path = util.parse_url(bufname)
    local prefix = '/storage/emulated/0/'
    if string.sub(path, 1, #prefix) == prefix then
      return true
    else
      -- Fall through to original function
      return orig(bufnr)
    end
  end
  file_mod._is_modifiable_monkeypatched = true
end
