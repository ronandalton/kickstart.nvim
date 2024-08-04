return {
  'mg979/vim-visual-multi',
  cond = false,
  init = function()
    -- Hack around issue with conflicting insert mode <BS> mapping
    -- between this plugin and nvim-autopairs
    vim.api.nvim_create_autocmd('User', {
      pattern = 'visual_multi_start',
      callback = function()
        vim.keymap.del('i', '<BS>', { buffer = 0 })
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'visual_multi_exit',
      callback = function()
        require('nvim-autopairs').force_attach()
      end,
    })
  end,
}
