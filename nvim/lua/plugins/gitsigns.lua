return {
  {
    'lewis6991/gitsigns.nvim',
    keys = {
      { ']c',         function() package.loaded.gitsigns.next_hunk() end,                 desc = 'Next hunk', },
      { '[c',         function() package.loaded.gitsigns.prev_hunk() end,                 desc = 'Previous hunk', },

      { '<leader>hs', function() package.loaded.gitsigns.stage_hunk() end,                desc = 'Stage hunk',                   mode = { 'n', 'v' }, },
      { '<leader>hr', function() package.loaded.gitsigns.reset_hunk() end,                desc = 'Reset hunk',                   mode = { 'n', 'v' }, },
      { '<leader>hu', function() package.loaded.gitsigns.undo_stage_hunk() end,           desc = 'Unstage hunk' },
      { '<leader>hp', function() package.loaded.gitsigns.preview_hunk() end,              desc = 'Preview hunk' },

      { '<leader>hS', function() package.loaded.gitsigns.stage_buffer() end,              desc = 'Stage buffer' },
      { '<leader>hR', function() package.loaded.gitsigns.reset_buffer() end,              desc = 'Reset buffer' },

      { '<leader>hb', function() package.loaded.gitsigns.blame_line({ full = true }) end, desc = 'Blame line' },
      { '<leader>htb', function() package.loaded.gitsigns.toggle_current_line_blame() end, desc = 'Toggle blame for current line' },

      -- TODO: fix descriptions
      { '<leader>hd', function() package.loaded.gitsigns.diffthis() end,                  desc = 'Diff view' },

      { '<leader>htd', function() package.loaded.gitsigns.toggle_deleted() end,            desc = 'Toggle deleted' },

      { 'ih',         function() package.loaded.gitsigns.select_hunk() end,               desc = 'Select inside hunk',           mode = { 'o', 'x' }, },

    },
    opts = {
      on_attach                    = function(bufnr) end,
      signs                        = {
        add          = { text = '▌' },
        change       = { text = '▌' },
        delete       = { text = '▁' },
        topdelete    = { text = '▔' },
        changedelete = { text = '▙' },
        untracked    = { text = '▞' },
      },
      signcolumn                   = true,
      numhl                        = true,
      linehl                       = false,
      word_diff                    = false,
      watch_gitdir                 = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked          = false,
      current_line_blame           = false,
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,
      max_file_length              = 40000,
      preview_config               = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    },
  }
}
