return {
  'stevearc/oil.nvim',
  lazy = false, -- needed to allow directories to be opened at startup
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Oil',
  keys = {
    { '<leader>o', '<cmd>Oil --float<CR>', desc = 'Open [O]il file manager' },
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
  },
}
