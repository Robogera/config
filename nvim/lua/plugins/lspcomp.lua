-- why do I need this?
local on_attach = function(client, bufnr)
end

return {
  {
    'echasnovski/mini.completion',
    version = false,
    opts = {
      window = {
        info = { height = 25, width = 80, border = "double" },
        signature = { height = 25, width = 80, border = "double" },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    keys = {
      { '<leader>lf',  function() vim.lsp.buf.format { async = true } end, desc = 'Format buffer' },
      { '<leader>la',  vim.lsp.buf.code_action,                            desc = 'Code action' },
      { '<leader>ln',  vim.lsp.buf.rename,                                 desc = 'Rename' },

      { 'K',           vim.lsp.buf.hover,                                  desc = 'Hover' },
      { '<C-k>',       vim.lsp.buf.signature_help,                         desc = 'Signature help' },

      { '<leader>gd',  vim.lsp.buf.declaration,                            desc = 'Go to declaration' },
      { '<leader>gD',  vim.lsp.buf.definition,                             desc = 'Go to definition' },
      { '<leader>gi',  vim.lsp.buf.implementation,                         desc = 'Go to implementation' },
      { '<leader>gtd', vim.lsp.buf.type_definition,                        desc = 'Go to type definition' },
      { '<leader>gr',  vim.lsp.buf.references,                             desc = 'References' },
    },
    dependencies = {
      { 'echasnovski/mini.completion', version = false },
    },
    config = (function(_, _)
      require('mini.completion').setup()

      local on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
      end

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          on_init(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })
      vim.lsp.enable('lua_ls')

      local lsps = { 'rust_analyzer', 'gopls', 'clangd', 'ansiblels', 'ocamllsp' }
      for _, lsp in ipairs(lsps) do
        vim.lsp.config(lsp, {
          on_init = on_init,
        })
        vim.lsp.enable(lsp)
      end
      -- vim.api.nvim_set_hl(0, "@lsp", {})
      -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      --   vim.api.nvim_set_hl(0, group, {})
      -- end
    end),
  },
}
