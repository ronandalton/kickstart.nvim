return {
  'stevearc/oil.nvim',
  lazy = false, -- needed to allow directories to be opened at startup
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Oil',
  keys = {
    { '<leader>oo', '<cmd>Oil --float<CR>', desc = '[O]pen [O]il file manager' },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 3,
      max_width = 140,
      max_height = 40,
    },
    keymaps = {
      ['<Esc><Esc>'] = 'actions.close',
      ['<C-s>'] = false, -- don't clobber <c-s> to save
      ['<C-S-s>'] = 'actions.select_vsplit',
    },
  },
}
