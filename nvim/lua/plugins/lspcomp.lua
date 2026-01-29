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
      { '<leader>lf',     function() vim.lsp.buf.format { async = true } end, desc = 'Format buffer' },
      { '<leader>la',     vim.lsp.buf.code_action,                            desc = 'Code action' },
      { '<leader>ln',     vim.lsp.buf.rename,                                 desc = 'Rename' },

      { 'K',      vim.lsp.buf.hover,                                  desc = 'Hover' },
      { '<C-k>',  vim.lsp.buf.signature_help,                         desc = 'Signature help' },

      { '<leader>gd',     vim.lsp.buf.declaration,                            desc = 'Go to declaration' },
      { '<leader>gD',     vim.lsp.buf.definition,                             desc = 'Go to definition' },
      { '<leader>gi',     vim.lsp.buf.implementation,                         desc = 'Go to implementation' },
      { '<leader>gtd', vim.lsp.buf.type_definition,                        desc = 'Go to type definition' },
      { '<leader>gr',     vim.lsp.buf.references,                             desc = 'References' },
    },
    dependencies = {
      { 'echasnovski/mini.completion', version = false },
    },
    config = (function(_, _)
      require('mini.completion').setup()
      vim.lsp.config('lua_ls', {
        on_init = function(client)
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
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('gopls')
      -- vim.lsp.config('ocamllsp', {
      --   cmd = { 'opam exec -- ocamllsp' },
      -- }
      -- )
      vim.lsp.enable('ocamllsp')
    end),
  },
}
