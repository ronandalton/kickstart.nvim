return {
  'chaoren/vim-wordmotion',
  init = function()
    vim.g.wordmotion_mappings = {
      -- Hold alt while using w/b/e/ge to move within an identifier
      ['w'] = '<m-w>',
      ['b'] = '<m-b>',
      ['e'] = '<m-e>',
      ['ge'] = '<m-g><m-e>',
      -- Alt-w text object is available too (e.g. ci<m-w>)
      ['aw'] = 'a<m-w>',
      ['iw'] = 'i<m-w>',
      -- Disable other default mappings (these seem to match the default but disable just to be safe)
      ['W'] = '',
      ['B'] = '',
      ['E'] = '',
      ['gE'] = '',
      ['aW'] = '',
      ['iW'] = '',
      -- Not sure what this should do anyway
      ['<C-R><C-W>'] = '',
      ['<C-R><C-A>'] = '',
    }
  end,
}
