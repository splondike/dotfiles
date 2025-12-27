local M = {}

-- Helper to register an LSP that is implemented in-process.
---@param name string
---@param options table
function M.register_in_process_lsp(name, options)
  local ms = vim.lsp.protocol.Methods
  local capabilities_list = {
    -- Go to definition
    definition = { capability_name = 'definitionProvider', handler_name = ms.textDocument_definition },
    -- Autocomplete
    completion = { capability_name = 'completionProvider', handler_name = ms.textDocument_completion },
  }
  local lsp_handlers = {}
  local capabilities = {}
  for handler_name, handler in pairs(options.handlers) do
    local data = capabilities_list[handler_name]
    if data ~= nil then
      capabilities[data.capability_name] = (options.capabilities or {})[handler_name] or {}
      lsp_handlers[data.handler_name] = handler
    else
      vim.notify('Unknown capability, skipping: ' .. handler_name, vim.log.levels.WARN)
    end
  end

  lsp_handlers[ms.initialize] = function(_, callback)
    callback(nil, {
      capabilities = capabilities,
      serverInfo = {
        name = name .. '-lsp',
        version = '1.0.0',
      },
    })
  end

  vim.lsp.config[name] = {
    filetypes = options.filetypes,
    cmd = function()
      return {
        request = function(method, params, callback)
          if lsp_handlers[method] then
            lsp_handlers[method](params, callback)
          end
        end,
        notify = function() end,
        is_closing = function() end,
        terminate = function() end,
      }
    end,
    root_dir = options.root_dir,
  }

  -- This little loop is necessary to get Neovim to update the running LSP code if you
  -- `source %` this file.
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == name then
      for bufnr, _ in pairs(client.attached_buffers) do
        vim.lsp.buf_detach_client(bufnr, client.id)
      end
      vim.lsp.stop_client(client.id, true)
    end
  end
  vim.lsp.enable(name, true)
end

return M
