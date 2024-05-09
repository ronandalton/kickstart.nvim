return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {
      settings = {
        save_on_toggle = true, -- ensure changes to harpoon list are kept when exiting it
      },
    }

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<leader>i', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<leader>j', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader>k', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader>l', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<leader>;', function()
      harpoon:list():select(4)
    end)
  end,
}
