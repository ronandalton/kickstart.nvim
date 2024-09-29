return {
  'stevearc/aerial.nvim',
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    -- Give LSP backend priority over treesitter.
    -- Treesitter has some problems with C files so use LSP if available.
    -- https://github.com/stevearc/aerial.nvim/issues/413
    backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },

    disable_max_lines = 20000,
    on_attach = function(bufnr)
      vim.keymap.set('n', '<M-[>', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<M-]>', '<cmd>AerialNext<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<leader>ds', require('telescope').extensions.aerial.aerial, { buffer = bufnr, desc = 'TS: [D]ocument [S]ymbols' })
    end,
  },
  config = function(_, opts)
    require('aerial').setup(opts)
    vim.keymap.set('n', '<leader>oo', '<cmd>AerialToggle!<CR>', { desc = '[O]pen [o]verview window' })
  end,
}
