return {
  'MagicDuck/grug-far.nvim',
  opts = {
    history = {
      autoSave = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require('grug-far').setup(opts)

    vim.keymap.set('n', '<leader>og', '<cmd>GrugFar<CR>', { desc = '[O]pen [g]rug-far find/replace UI' })
  end,
}
