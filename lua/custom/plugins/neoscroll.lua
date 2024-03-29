return {
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup {
      easing_function = 'quadratic',
    }

    local t = {}
    -- Syntax: t[keys] = {function, {function arguments}}
    t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '170' } }
    t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '170' } }
    t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '220' } }
    t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '220' } }
    t['<C-y>'] = { 'scroll', { '-0.10', 'false', '80' } }
    t['<C-e>'] = { 'scroll', { '0.10', 'false', '80' } }
    t['zt'] = { 'zt', { '75' } }
    t['zz'] = { 'zz', { '90' } }
    t['zb'] = { 'zb', { '75' } }

    require('neoscroll.config').set_mappings(t)
  end,
}
