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

  { 'kylechui/nvim-surround' },

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
