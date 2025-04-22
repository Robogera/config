-- why do I need this?
local on_attach = function(client, bufnr)
end

return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    keys = {
      { '<leader>fm',     function() vim.lsp.buf.format { async = true } end, desc = 'Format buffer' },
      { '<leader>ca',     vim.lsp.buf.code_action,                            desc = 'Code action' },
      { '<leader>rf',     vim.lsp.buf.references,                             desc = 'References' },
      { '<leader>rn',     vim.lsp.buf.rename,                                 desc = 'Rename' },

      { '<leader>K',      vim.lsp.buf.hover,                                  desc = 'Hover' },
      { '<leader><C-k>',  vim.lsp.buf.signature_help,                         desc = 'Signature help' },

      -- { '<leader>gd',     vim.lsp.buf.declaration,                            desc = 'Go to declaration' },
      -- { '<leader>gD',     vim.lsp.buf.definition,                             desc = 'Go to definition' },
      -- { '<leader>gi',     vim.lsp.buf.implementation,                         desc = 'Go to implementation' },
      { '<leader>g<C-d>', vim.lsp.buf.type_definition,                        desc = 'Go to type definition' },
    },
    dependencies = {
      { 'echasnovski/mini.completion', version = false },
    },
    config = (function(_, _)
      require('mini.completion').setup()
      local lsp = require 'lspconfig'
      lsp.gopls.setup({
        on_attach = on_attach,
      })
      lsp.rust_analyzer.setup({
        on_attach = on_attach,
      })
      lsp.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end),
  },
}
