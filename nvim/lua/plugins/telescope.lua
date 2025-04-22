return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    keys = {
      { '<leader><leader>', function() require('telescope.builtin').find_files() end,               desc = 'Files' },

      { '<leader>fb',       function() require('telescope.builtin').buffers() end,                  desc = 'Buffers' },
      { '<leader>fh',       function() require('telescope.builtin').help_tags() end,                desc = 'Help tags' },
      { '<leader>fg',       function() require('telescope.builtin').live_grep() end,                desc = 'Live grep' },
      { '<leader>fs',       function() require('telescope.builtin').git_status() end,               desc = 'Git status' },
      { '<leader>fc',       function() require('telescope.builtin').git_commits() end,              desc = 'Git commits' },
      { '<leader>fc',       function() require('telescope.builtin').git_bcommits() end,             desc = 'Git commits for buffer',           mode = 'n' },
      -- TODO: what the fuck are x and o modes?
      { '<leader>fc',       function() require('telescope.builtin').git_bcommits_range() end,       desc = 'Git commits for selection',        mode = { 'v', 'x', 'o' }, },

      { '<leader>gd',       function() require('telescope.builtin').lsp_definitions() end,          desc = 'LSP definitions', },
      { '<leader>gi',       function() require('telescope.builtin').lsp_implementations() end,      desc = 'LSP implementations', },
      { '<leader>gt',       function() require('telescope.builtin').lsp_type_definitions() end,     desc = 'LSP type definition', },

      { '<leader>fd',       function() require('telescope.builtin').diagnostics() end,              desc = 'LSP diagnostics', },
      { '<leader>fD',       function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, desc = 'LSP diagnostics (current buffer)', },
    },
  },
}
