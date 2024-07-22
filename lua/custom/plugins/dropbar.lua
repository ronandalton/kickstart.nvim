local function get_custom_treesitter_source()
  local bar = require 'dropbar.bar'
  return {
    get_symbols = function(_, _, _)
      local data = require('nvim-gps').get_data()

      if data == nil then
        return {}
      end

      local symbols = {}

      for _, item in ipairs(data) do
        table.insert(
          symbols,
          bar.dropbar_symbol_t:new {
            -- Note we just highlight each symbol as if it's a function for simplicity
            icon = item.icon,
            icon_hl = 'DropBarIconKindFunction',
            name = item.text,
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
    {
      'ColinKennedy/nvim-gps', -- fork of SmiteshP/nvim-gps (which is archived) with some bug fixes
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
      },
      opts = {},
    },
  },
  opts = {
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
