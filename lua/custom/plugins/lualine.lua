return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- Customize status line appearance for specific buffer types
    extensions = {
      'quickfix',
      'man',
      'lazy',
      'mason',
      'nvim-dap-ui',
      'fugitive',
      'neo-tree',
      'oil',
    },
    inactive_sections = {
      lualine_c = {
        {
          'filename',
          path = 1, -- use relative file path
        },
      },
    },
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1, -- use relative file path
        },
      },
    },
    options = {
      disabled_filetypes = {
        statusline = {
          'dashboard',
        },
      },
    },
  },
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}
