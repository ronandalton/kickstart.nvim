return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {},
  config = function(_, opts)
    require('toggleterm').setup(opts)

    vim.keymap.set('n', '<leader>ot', '<cmd>ToggleTerm<CR>', { desc = '[O]pen [t]erminal' })
  end,
}
