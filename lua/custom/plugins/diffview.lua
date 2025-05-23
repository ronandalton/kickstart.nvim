return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewFocusFiles', 'DiffviewToggleFiles', 'DiffviewRefresh', 'DiffviewLog' },
  keys = { { '<leader>od', '<cmd>DiffviewOpen<cr>', desc = '[O]pen [D]iff View' } },
  opts = {
    view = {
      merge_tool = {
        layout = 'diff1_plain',
      },
    },
  },
}
