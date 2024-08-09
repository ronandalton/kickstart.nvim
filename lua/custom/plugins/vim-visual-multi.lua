return {
  'mg979/vim-visual-multi',
  init = function()
    vim.g.VM_maps = {
      -- Square braces couldn't be mapped because of some conflict with
      -- which-key so use curly braces instead
      ['Goto Next'] = '}',
      ['Goto Prev'] = '{',
    }

    -- Hack around issue with conflicting insert mode <BS> mapping
    -- between this plugin and nvim-autopairs
    vim.api.nvim_create_autocmd('User', {
      pattern = 'visual_multi_start',
      callback = function()
        pcall(vim.keymap.del, 'i', '<BS>', { buffer = 0 })

        ---@diagnostic disable-next-line: missing-parameter
        require('lualine').hide()
        require('illuminate').pause()
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'visual_multi_exit',
      callback = function()
        require('nvim-autopairs').force_attach()

        ---@diagnostic disable-next-line: missing-fields
        require('lualine').hide { unhide = true }
        require('illuminate').resume()
      end,
    })
  end,
}
