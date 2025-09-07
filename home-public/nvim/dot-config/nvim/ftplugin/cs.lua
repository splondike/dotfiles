-- replaces vim.lsp.buf.definition()
vim.b.lsp_definitions = function()
  require('omnisharp_extended').lsp_definition()
end

vim.b.lsp_references = function()
  require('omnisharp_extended').lsp_references()
end
