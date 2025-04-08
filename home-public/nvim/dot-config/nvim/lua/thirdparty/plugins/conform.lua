return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      {
        '<leader>llf',
        function()
          if vim.b.enable_autoformat == nil then
            vim.b.enable_autoformat = true
          else
            vim.b.enable_autoformat = not vim.b.enable_autoformat
          end
          print('Autoformat set to ' .. tostring(vim.b.enable_autoformat))
        end,
        mode = 'n',
        desc = 'Toggle autoformat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.b.enable_autoformat == true then
          return {
            timeout_ms = 500,
            lsp_fallback = true,
          }
        elseif vim.b.enable_autoformat == false then
          return
        else
          local enable_filetypes = { lua = true, go = true }
          if enable_filetypes[vim.bo[bufnr].filetype] then
            return {
              timeout_ms = 500,
              lsp_fallback = true,
            }
          else
            return
          end
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        go = { 'goimports', 'gofmt' },
        terraform = { 'terraform_fmt' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
