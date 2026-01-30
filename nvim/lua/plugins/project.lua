return {
  {
    'coffebar/neovim-project',
    keys = {
      { '<leader>pp', ':NeovimProjectDiscover<cr>',   desc = 'Show all projects' },
      { '<leader>pl', ':NeovimProjectLoadRecent<cr>', desc = 'Load last project' },
      { '<leader>ph', ':NeovimProjectHistory<cr>',    desc = 'Show recent projects' },
    },
    opts = {
      projects = {
        '~/dev/*',
        '~/.config/',
        '~/Documents/slavemail/',
      },
      forget_project_keys = {},
      picker = {
        type = 'telescope',

        preview = {
          enabled = false,
          git_status = true,
          git_fetch = false,
          show_hidden = true,
        },
      }
    },
    init = function()
      vim.opt.sessionoptions:append('globals')
    end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'Shatur/neovim-session-manager' },
    },
    lazy = false,
    priority = 100,
  },
}
