return {
  { 'nvim-lua/plenary.nvim',  lazy = true },

  { 'sindrets/diffview.nvim', lazy = true },

  {
    'echasnovski/mini.base16',
    version = false,
    opts = {
      plugins = {
        default = true,
      },
      palette = {
        base00 = '#0f3b3a',
        base01 = '#0d3433',
        base02 = '#3C716E',
        base03 = '#638E8B',
        base04 = '#000000', -- ??
        base05 = '#f0f0f0', -- text
        base06 = '#000000', -- ??
        base07 = '#000000', -- ??
        base08 = '#a64a2e', -- red evil stuff
        base09 = '#b154cf', -- integers
        base0A = '#f15f22', -- ocaml types
        base0B = '#009703', -- strings
        base0C = '#00ff00', -- rust type names
        base0D = '#40a4b9', -- function names
        base0E = '#e99f10', -- keywords
        base0F = '#b1c9c3', -- parens
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    opts = {
      highlight = { enable = true, },
      indent = { enable = true },
      sync_install = true,
      ensure_installed = {
        -- shells
        'bash',
        'fish',
        -- markup
        'markdown',
        'markdown_inline',
        'html',
        'typst',
        -- data
        'json',
        'yaml',
        'toml',
        -- configs
        'tmux',
        -- pls
        'lua',
        'javascript',
        'python',
        'query',
        'regex',
        'vim',
        'go',
        'rust',
        'elixir',
        'cpp',
        'c',
        'scala',
        'haskell',
        'ocaml'
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
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
    -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
  },

  {
    'nvim-mini/mini.pick',
    opts = {},
    lazy = false,
    version = false
  },
}
