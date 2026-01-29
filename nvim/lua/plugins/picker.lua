return {
  {
    'nvim-mini/mini.pick',
    config = (function(_, _)
      local pick = require('mini.pick')
      pick.setup({ source = { show = pick.default_show }, window = { config = { border = 'solid' } } })
    end),
    lazy = false,
    version = false,
    keys = {
      { '<leader>ff', function() require('mini.pick').builtin.files({ tool = 'git' }) end, desc = 'Files' },
      { '<leader>fb', function() require('mini.pick').builtin.buffers({}) end,             desc = 'Buffers' },
      { '<leader>fg', function() require('mini.pick').builtin.grep_live({}) end,           desc = 'Grep' },
    },
  },
}
