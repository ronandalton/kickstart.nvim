return {
  'lukas-reineke/indent-blankline.nvim',
  version = '2.20.7', -- Older version works better (shows proper context) for python
  main = 'indent_blankline',
  opts = {
    char = '▏',
    context_char = '▏',
    filetype_exclude = {
      -- copied from latest version defaults
      'lspinfo',
      'packer',
      'checkhealth',
      'help',
      'man',
      'gitcommit',
      'TelescopePrompt',
      'TelescopeResults',
      '',
    },
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    show_current_context = true,
    viewport_buffer = 80,
    indent_level = 50,
  },
}
