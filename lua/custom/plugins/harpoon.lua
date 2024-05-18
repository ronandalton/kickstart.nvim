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
    end, { desc = '(Harpoon) Add file' })
    vim.keymap.set('n', '<leader>i', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '(Harpoon) Toggle UI' })

    vim.keymap.set('n', '<leader>j', function()
      harpoon:list():select(1)
    end, { desc = '(Harpoon) Select file 1' })
    vim.keymap.set('n', '<leader>k', function()
      harpoon:list():select(2)
    end, { desc = '(Harpoon) Select file 2' })
    vim.keymap.set('n', '<leader>l', function()
      harpoon:list():select(3)
    end, { desc = '(Harpoon) Select file 3' })
    vim.keymap.set('n', '<leader>;', function()
      harpoon:list():select(4)
    end, { desc = '(Harpoon) Select file 4' })
  end,
}
