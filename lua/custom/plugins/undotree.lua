return {
  'mbbill/undotree',
  cmd = {
    'UndotreeToggle',
    'UndotreeHide',
    'UndotreeShow',
    'UndotreeFocus',
    'UndotreePersistUndo',
  },
  keys = {
    { '<leader>ou', '<cmd>UndotreeToggle<CR>', desc = '[O]pen [u]ndo tree' },
  },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
