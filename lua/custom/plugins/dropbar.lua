local function get_custom_treesitter_source()
  local bar = require 'dropbar.bar'
  return {
    get_symbols = function(_, _, _)
      local items = require('aerial').get_location(true)

      local symbols = {}

      for _, item in ipairs(items) do
        table.insert(
          symbols,
          bar.dropbar_symbol_t:new {
            -- Note we just highlight each symbol as if it's a function for simplicity
            icon = item.icon,
            icon_hl = 'DropBarIconKindFunction',
            name = item.name,
            name_hl = 'DropBarKindFunction',
            on_clock = nil,
          }
        )
      end

      return symbols
    end,
  }
end

return {
  'Bekaboo/dropbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-fzf-native.nvim',
    'stevearc/aerial.nvim',
  },
  opts = {
    sources = {
      path = {
        -- Make the path component show only the folder the current file is in
        relative_to = function(buf)
          local file_path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))

          if file_path == '' then
            return ''
          end

          return vim.fs.dirname(file_path)
        end,
      },
    },
    bar = {
      sources = function(buf, _)
        local sources = require 'dropbar.sources'
        local utils = require 'dropbar.utils'
        local custom_treesitter_source = get_custom_treesitter_source()
        if vim.bo[buf].ft == 'markdown' then
          return {
            sources.path,
            sources.markdown,
          }
        end
        if vim.bo[buf].buftype == 'terminal' then
          return {
            sources.terminal,
          }
        end
        return {
          sources.path,
          utils.source.fallback {
            sources.lsp,
            custom_treesitter_source,
          },
        }
      end,
    },
  },
}
