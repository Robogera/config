return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = (function(_, _)
      local grammars = {
        'lua',
        'rust',
        'ocaml',
        'c',
        'cpp',
        'make',
        'bash',
        'python',
        'yaml',
        'fish',
        'perl',
      }
      require 'nvim-treesitter'.install(grammars)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = grammars,
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end),
  }
