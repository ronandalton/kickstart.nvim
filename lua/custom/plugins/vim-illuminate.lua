return {
  'RRethy/vim-illuminate',
  opts = {
    providers = {
      'lsp',
      -- 'treesitter', -- can be really slow on large files
      'regex',
    },
    -- only do highlighting when in normal mode
    modes_allowlist = { 'n', 'no', 'nov', 'noV', 'noCTRL-V', 'nt' },
  },
  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
