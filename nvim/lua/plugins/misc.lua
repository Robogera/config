return {
  { 'nvim-lua/plenary.nvim',  lazy = true },

  { 'sindrets/diffview.nvim', lazy = true },

  {
    'echasnovski/mini.statusline',
    version = false,
    opts = {
      use_icons = false,
    },
  },

  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {
      icons = {
        breadcrumb = ">>", -- symbol used in the command line area that shows your active key combo
        separator = "->",  -- symbol used between a key and it's label
        group = "+",       -- symbol prepended to a group
        ellipsis = "...",
        mappings = false,
        rules = {},
        colors = true,
        keys = {
          Up = "",
          Down = "",
          Left = "",
          Right = "",
          C = "",
          M = "",
          D = "",
          S = "",
          CR = "",
          Esc = "",
          ScrollWheelDown = "",
          ScrollWheelUp = "",
          NL = "",
          BS = "",
          Space = "",
          Tab = "",
          F1 = "",
          F2 = "",
          F3 = "",
          F4 = "",
          F5 = "",
          F6 = "",
          F7 = "",
          F8 = "",
          F9 = "",
          F10 = "",
          F11 = "",
          F12 = "",
        },
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'nvim-mini/mini.surround',
    version = false,
    opts = {
      mappings = {
        add = 'ma',
        delete = 'md',
        find = 'mf',
        find_left = 'mF',
        highlight = 'mh',
        replace = 'mr',

        suffix_last = 'l',
        suffix_next = 'n',
      },
    }
  },

  {
    'nativerv/cyrillic.nvim',
    event = { 'VeryLazy' },
    opts = {
      no_cyrillic_abbrev = false,
    },
  },

  -- {
  --   "xiyaowong/transparent.nvim",
  --   lazy = false,
  -- },

  {
    'stevearc/oil.nvim',
    opts = {
      columns = {
        "permissions", "size", "mtime",
      }
    },
    lazy = false,
  },

}
