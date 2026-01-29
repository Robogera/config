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

  { 'folke/which-key.nvim' },

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

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  },

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
