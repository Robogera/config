return {
  {
    'smoka7/hop.nvim',
    config = (function(_, _)
      require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran',
        uppercase_labels = true,
        create_hl_autocommand = false,
      })
      local set_highlights = function()
        local set = vim.api.nvim_set_hl
        set(0, 'HopNextKey', { ctermfg = 1})
        -- Highlight used for the first key in a sequence.
        set(0, 'HopNextKey1', { ctermfg = 14})
        -- Highlight used for the second and remaining keys in a sequence.
        set(0, 'HopNextKey2', { ctermfg = 6})
        -- Highlight used for the unmatched part of the buffer.
        set(0, 'HopUnmatched', { ctermfg = 7})
        -- Highlight used for the fake cursor visible when hopping.
        set(0, 'HopCursor', { link = 'Cursor'})
        -- Highlight used for preview pattern
        set(0, 'HopPreview', { link = 'IncSearch'})
      end
      set_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {

        group = vim.api.nvim_create_augroup('HopInitHighlight', {
          clear = true,
        }),
        callback = set_highlights,
      })
    end),
    keys = {
      { 's', function() require('hop').hint_words({ current_line_only = false }) end,                       desc = 'Hop to word',                 remap = true },
      { 'S', function() require('hop').hint_words({ current_line_only = false, multi_windows = true }) end, desc = 'Hop to word (across splits)', remap = true },
    },
  }
}
