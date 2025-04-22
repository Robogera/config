return {
  {
    'smoka7/hop.nvim',
    opts = { keys = 'etovxqpdygfblzhckisuran' },
    keys = {
      { 'f', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true }) end,                   desc = 'Hop to the right',                 remap = true },
      { 'F', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true }) end,                  desc = 'Hop to the left',                  remap = true },

      { 't', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, desc = 'Hop to the right (before symbol)', remap = true },
      { 'T', function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, desc = 'Hop to the left (before symbol)',  remap = true },

      { 's', function() require('hop').hint_words({ current_line_only = false }) end,                                                                              desc = 'Hop to word',                      remap = true },
      { 'S', function() require('hop').hint_char2({ current_line_only = false }) end,                                                                              desc = 'Hop to 2-char',                    remap = true },
    },
  }
}
