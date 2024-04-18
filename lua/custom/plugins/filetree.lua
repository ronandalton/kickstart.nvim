-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.keymap.set('n', '<leader>nf', '<cmd>Neotree toggle reveal<CR>', { desc = '[N]eotree toggle [f]ile view' })
    vim.keymap.set('n', '<leader>ng', '<cmd>Neotree toggle git_status<CR>', { desc = '[N]eotree toggle [G]it view' })

    require('neo-tree').setup {
      filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    }
  end,
}
