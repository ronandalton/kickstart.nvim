return {
  'stevearc/oil.nvim',
  lazy = false, -- needed to allow directories to be opened at startup
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Oil',
  keys = {
    { '<leader>of', '<cmd>Oil --float<CR>', desc = '[O]pen [f]ile manager (Oil)' },
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
  config = function(_, opts)
    require('oil').setup(opts)

    -- Mimic some commands that would have been provided by Netrw
    vim.api.nvim_create_user_command('Explore', 'Oil', {})
    vim.api.nvim_create_user_command('Hexplore', 'belowright split | Oil', {})
    vim.api.nvim_create_user_command('Sexplore', 'split | Oil', {})
    vim.api.nvim_create_user_command('Vexplore', 'leftabove vertical Oil', {})
    vim.api.nvim_create_user_command('Texplore', 'tab Oil', {})
  end,
}
