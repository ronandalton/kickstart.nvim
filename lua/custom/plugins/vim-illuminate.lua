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
    filetypes_denylist = {
      'qf',
      'help',
      'lspinfo',
      'checkhealth',
      'tutor',
      'man',
      'query',
      'diff',
      'git',
      'lazy',
      'mason',
      'aerial',
      'fugitive',
      'fugitiveblame',
      'neo-tree',
      'oil',
      'DiffviewFileHistory',
      'DiffviewFiles',
      'TelescopePrompt',
      'TelescopeResults',
      'harpoon',
      'leetcode.nvim',
      'dashboard',
    },
  },
  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
