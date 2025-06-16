-- This config is adapted from LazyVim's dashboard-nvim config and uwuified :3
-- Credit to hyyperb on Discord for the concept and logo text
return {
  'nvimdev/dashboard-nvim',
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  enabled = function()
    return vim.fn.environ()['NYAA_VIM'] ~= nil
  end,
  opts = function()
    local logo = [[
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡤⣶⡤⣤⠀⠀       
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠶⠛⢉⡼⠛⠁⣠⡟⠀⠀       
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡤⠖⠛⠉⠉⠽⠓⠒⠓⠒⠿⠉⠛⠒⠦⣤⡀⠀⣠⡶⠋⠁⠀⢠⡟⠀⠀⠴⠟⠛⢳⡆       
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⣶⡶⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢯⡀⠀⠀⢀⡏⡆⠀⠀⠀⢀⣼⣋⡅       
      ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠴⠚⠉⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠲⣄⣸⠁⠀⠀⠀⠀⠉⠀⣸⡇       
      ⠀⠀⠀⠀⣀⣠⠴⠞⠋⠀⣀⡴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⣄⠀⠀⠀⢀⣴⠏⠀       
      ⣤⡴⠒⠛⠉⠀⠀⠐⠒⠛⣷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⣌⣛⣒⣤⠿⠟⣶⠆       
      ⢹⣧⡀⠀⠀⠀⠀⠀⠀⣼⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠉⠀⠀⣰⠏⠀       
      ⠀⢿⡷⣄⠀⠀⠀⠀⢰⡷⠋⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠉⠛⣯⠀⠀       
      ⠀⠈⢷⣈⠙⢶⣒⠛⠋⢠⠞⠀⠀⠀⠀⠀⡴⠀⢠⡏⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⣿⡦⣴⠟⠁⠀⠀       
      ⠀⠀⠀⢹⡟⠂⠩⠛⢲⡏⠀⠀⠀⠀⠀⢰⡇⣀⣿⠀⢸⠀⠀⠀⠀⠀⠀⡄⠀⠐⢺⢷⠂⠰⡄⠀⢸⡀⠀⠀⠀⠀⠀⠀⠹⣟⡁⠀⠀⠀⠀       
      ⠀⠀⠀⠈⠛⠲⢶⠀⡾⠀⠀⠀⠀⠀⢠⢸⡷⠫⢸⡆⢸⣆⠀⠀⠀⠀⠀⢳⠀⢀⡿⠘⢧⡀⢹⣄⠀⣧⠀⠀⠀⠀⠀⠀⠀⠈⠙⠲⢤⣤⡆       
      ⠀⠀⠀⠀⠀⠀⠈⢹⠁⢰⠀⠀⠀⠀⢸⢸⡅⠀⠀⠻⣎⣿⢦⣀⠀⠀⠀⣸⡀⣼⣷⣾⣿⣿⣾⣿⢦⣿⠀⠀⠀⠀⠀⠀⠀⢷⠦⠴⠖⠋⠁       
      ⠀⠀⠀⠀⠀⠀⠀⢸⠀⢸⡄⠀⠀⠀⣿⠸⣇⠀⠀⠀⠈⠙⠂⠙⠷⣄⣀⣿⠟⢿⣿⡏⣀⡀⢙⣿⣿⣏⡀⠀⠀⠀⠀⢸⡀⠸⡆⠀⠀⠀⠀       
      ⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⣿⡀⠀⠀⢸⡷⢿⣶⣶⣦⣍⡢⠀⠀⠀⠀⠙⠀⠀⢸⣟⠉⠽⠿⠍⣻⣿⠟⠀⠀⠀⠀⠀⣸⠁⢰⠇⠀⠀⠀⠀       
      ⠀⠀⠀⠀⠀⠀⠀⠀⠻⣄⣧⡿⢦⣄⡀⣷⠀⠀⠈⠉⠛⠻⢦⠀⠀⠀⠀⠀⠀⠠⠿⠤⠤⠤⢒⡿⠃⣠⡞⠀⠀⠀⣠⡏⢀⡞⠀⠀⠀⠀⠀       
      ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⠟⠁⠀⠉⢉⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⡯⠴⣺⣿⠀⠀⢀⡴⣿⡖⠋⠀⠀⠀⠀⠀⠀       
      ⠀⠀⠀⠀⢀⣠⡤⠶⠋⠁⠀⠀⠀⢀⡄⠈⢳⣄⠀⠀⠀⠀⠀⠠⣄⣠⣤⣀⡄⠀⠀⠀⠀⠀⢀⡴⠋⣯⣤⠖⠋⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀       
      ⠀⣠⡶⠚⠉⢁⡆⠀⠀⠀⠀⠀⠀⡞⠀⠀⠀⠈⠓⣶⣄⣀⠀⠀⠈⠉⠉⠁⠀⠀⠀⣀⡤⠞⠋⠀⠀⠀⡀⠀⠀⠀⠸⣷⠀⠀⠀⠀⠀⠀⠀       
      ⢸⠟⠀⠀⣴⡟⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⣴⣿⣿⣤⡉⠛⢿⡖⠦⠤⠤⠖⢛⣿⠋⠀⠀⠀⠀⠀⠀⢳⠀⠀⠀⠀⠹⣷⣄⡀⠀⢀⡀⠀       
      ⢸⠀⠀⢸⡿⠁⢠⡄⠀⠀⠀⠀⡇⠀⠀⢀⡼⠛⠻⣿⣮⣙⣦⡈⣿⣆⠀⠀⢀⡾⠛⢷⣤⡀⠀⠀⠀⠀⢸⠀⠀⠀⢰⡄⠙⣮⡉⠉⠉⠁⠀       
      ⠘⣧⠀⡏⡇⠀⠸⡇⠀⠀⠀⠀⢻⠀⢀⡏⠀⠀⠀⠘⣿⣿⣿⣷⣽⣿⣦⣤⣼⡇⢀⡿⢸⠿⣆⠀⠀⠀⠈⣧⠀⠀⠀⢳⡄⠈⠻⣆⠀⠀⠀       
      ⠀⠈⢷⣇⣧⡀⠀⢹⣄⠀⠀⠀⠈⣇⢸⠁⠀⠀⠀⠀⠨⣿⣿⣿⣿⣆⢹⣆⣸⢡⣿⣷⡟⣠⣿⡀⠀⠀⠀⣿⠀⠀⠀⠀⣿⢆⠀⠘⢷⡀⠀       
                                                                
  ███╗   ██╗██╗   ██╗ █████╗  █████╗    ██╗   ██╗██╗███╗   ███╗ 
  ████╗  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗   ██║   ██║██║████╗ ████║ 
  ██╔██╗ ██║ ╚████╔╝ ███████║███████║   ██║   ██║██║██╔████╔██║ 
  ██║╚██╗██║  ╚██╔╝  ██╔══██║██╔══██║   ╚██╗ ██╔╝██║██║╚██╔╝██║ 
  ██║ ╚████║   ██║   ██║  ██║██║  ██║    ╚████╔╝ ██║██║ ╚═╝ ██║ 
  ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝ 
    ]]

    logo = '\n\n' .. logo .. '\n\n'

    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, '\n'),
        -- stylua: ignore
        center = {
          { action = 'ene | startinsert',                                                             desc = ' New File',     icon = ' ', key = 'n' },
          { action = 'Telescope oldfiles',                                                            desc = ' Recent Files', icon = ' ', key = 'r' },
          { action = 'Telescope recent-files',                                                        desc = ' Find File',    icon = ' ', key = 'f' },
          { action = 'Telescope live_grep',                                                           desc = ' Find Text',    icon = ' ', key = 'g' },
          { action = 'lua require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }', desc = ' Config',       icon = ' ', key = 'c' },
          { action = function() vim.api.nvim_input('<cmd>qa<cr>') end,                                desc = ' Quit',         icon = ' ', key = 'q' },
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '🐱 Nyaa-vim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == 'lazy' then
      vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds('UIEnter', { group = 'dashboard' })
          end)
        end,
      })
    end

    return opts
  end,
}
