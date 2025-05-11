return {
  'karb94/neoscroll.nvim',
  opts = {
    easing_function = 'quadratic',
  },
  config = function(_, opts)
    require('neoscroll').setup(opts)

    neoscroll = require 'neoscroll'

    local keymaps = {
      -- stylua: ignore start
      ['<C-u>'] = function() neoscroll.ctrl_u { duration = 170 } end,
      ['<C-d>'] = function() neoscroll.ctrl_d { duration = 170 } end,
      ['<C-b>'] = function() neoscroll.ctrl_b { duration = 220 } end,
      ['<C-f>'] = function() neoscroll.ctrl_f { duration = 220 } end,
      ['<C-y>'] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 80 }) end,
      ['<C-e>'] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 80 }) end,
      ['zt'] = function() neoscroll.zt { half_win_duration = 75 } end,
      ['zz'] = function() neoscroll.zz { half_win_duration = 90 } end,
      ['zb'] = function() neoscroll.zb { half_win_duration = 75 } end,
      -- stylua: ignore end
    }

    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymaps) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
