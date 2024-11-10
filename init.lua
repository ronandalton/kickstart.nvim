--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Don't do any configuration if running from inside the VSCode Neovim extension
if vim.g.vscode then
  return
end

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Define the default colorscheme to load at startup in absence of a previous colorscheme
vim.g.COLORSCHEME = 'tokyonight-night'

-- Define the default light and dark theme variants for use by the theme toggle keymap
local dark_theme = 'tokyonight-night'
local light_theme = 'tokyonight-day'

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Use 4 space indents by default
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable spellcheck in places where it shouldn't be enabled
vim.cmd 'au TermOpen * setlocal nospell'
vim.cmd 'au FileType qf,checkhealth,git setlocal nospell'

-- Explicitly enable spellcheck for when writing git commit messages
vim.cmd 'au FileType gitcommit setlocal spell'

-- Disable spellcheckMap checking that words at the start of sentences are capitalized
vim.opt.spellcapcheck = ''

-- Spellcheck words in camel-case correctly
vim.opt.spelloptions:append 'camel'

-- Make the jump list behave like a stack instead of the slightly unusual way that it normally behaves
vim.opt.jumpoptions:append 'stack'

-- Restore view when jumping backwards and forwards
vim.opt.jumpoptions:append 'view'

-- Sync the jump stack and tag stack so ctrl-t and ctrl-o work together better
-- TODO: make code cleaner and more robust
local do_jump = function(jumping_backwards, is_big_jump)
  local send_keys = function(keys)
    local translated_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(translated_keys, 'n', false)
  end

  local win_id = vim.fn.win_getid()

  local tag_stack = vim.fn.gettagstack(win_id)
  local tag_idx = tag_stack.curidx

  local jump_locations, jump_idx = unpack(vim.fn.getjumplist(win_id))
  jump_idx = jump_idx + 1 -- 0-indexed but we want 1-indexed

  if jumping_backwards then
    if is_big_jump then
      if tag_idx <= 1 then
        -- no tag to jump back to, let nvim display error to user
        send_keys '<c-t>'
        return
      end
    else -- is small jump
      if jump_idx <= 1 then
        -- this should have no effect
        send_keys '<c-o>'
        return
      end
    end
  else -- jumping forwards
    if is_big_jump then
      if tag_idx > tag_stack.length then
        -- no tag to jump forward to, let nvim display error to user
        send_keys ':tag<CR>'
        return
      end
    else -- is small jump
      if jump_idx >= #jump_locations then
        -- this should have no effect
        send_keys '<c-i>'
        return
      end
    end
  end

  local dir = jumping_backwards and -1 or 1

  if is_big_jump then
    local target = tag_stack.items[tag_idx + (jumping_backwards and -1 or 0)]
    local count = 0
    local found_target = false

    for i = jump_idx + dir, dir == -1 and 1 or #jump_locations, dir do
      local this = jump_locations[i]
      count = count + 1

      if this.bufnr == target.from[1] and this.lnum == target.from[2] and this.col == target.from[3] - 1 then
        found_target = true
        break
      end
    end

    if found_target then
      vim.fn.settagstack(win_id, { curidx = tag_idx + dir })
      send_keys(tostring(count) .. (dir == -1 and '<c-o>' or '<c-i>'))
      return
    else
      -- TODO: handle error case where match isn't found
      return
    end
  else -- is small jump
    if not (jumping_backwards and tag_idx <= 1 or not jumping_backwards and tag_idx > tag_stack.length) then
      local next = jump_locations[jump_idx + (dir == -1 and -1 or 0)]
      local target = tag_stack.items[tag_idx + (jumping_backwards and -1 or 0)]

      if next.bufnr == target.from[1] and next.lnum == target.from[2] and next.col == target.from[3] - 1 then
        vim.fn.settagstack(win_id, { curidx = tag_idx + dir })
      end
    end

    send_keys(dir == -1 and '<c-o>' or '<c-i>')
    return
  end
end

vim.keymap.set('n', '<c-t>', function()
  do_jump(true, true)
end)

vim.keymap.set('n', '<c-o>', function()
  do_jump(true, false)
end)

vim.keymap.set('n', '<c-i>', function()
  do_jump(false, false)
end)

-- Make tab completion in command mode only complete up to the longest common prefix
vim.opt.wildmode = 'full:longest'

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 2

-- Fix issue with tag file lookups using linear search instead of binary search because ignorecase is true
vim.opt.tagcase = 'match'

-- Allow per project configuration via .exrc files
vim.opt.exrc = true

-- Customize shada to not save registers and search/command/input-line history
vim.opt.shada:append { '<0', '/0', ':0', '@0', "'500" }
vim.opt.shada:remove { '<50', "'100" }

-- Don't display intro screen on startup
vim.opt.shortmess:append 'I'

-- Fix lower priority LSP diagnostics being shown over higher priority ones
vim.diagnostic.config { severity_sort = true }

-- Start vim with an empty jump list
vim.cmd 'autocmd VimEnter * :clearjumps'

-- Fix odd Python indentation style
vim.cmd [[
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.continue = 'shiftwidth()'
let g:python_indent.closed_paren_align_last_line = v:false
]]

-- Enable the builtin cfilter plugin to allow filtering the quickfix list with the :Cfilter and :Lfilter commands
vim.cmd 'packadd cfilter'

-- Add improved :DiffOrig command
vim.cmd [[
function s:DiffOrig()
  let l:filetype = &ft
  let l:has_winbar = &winbar != ""
  noswapfile leftabove vert new
  if l:has_winbar
    " Work around alignment issue by adding empty winbar if needed
    setlocal winbar=\ 
  endif
  set buftype=nofile
  read ++edit #
  0d_
  exe "setlocal nomodifiable bufhidden=wipe nobuflisted filetype=" . l:filetype
  diffthis
  wincmd p
  diffthis
endfunction

command DiffOrig call s:DiffOrig()
]]

-- Allow deleting items in quickfix list with 'dd'
vim.cmd [[
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
]]

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybind to save current file
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })

-- Keymap for toggling spell check
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = '[T]oggle [s]pell check' })

-- Remap to yank a text region without the cursor moving to the start of the block
vim.keymap.set('v', 'y', 'ygv<Esc>')

-- Function to get the rhs of a mapping for j or k.
-- The resulting mapping will add to the jump list when jumping multiple lines
-- up or down and make movement more natural when line wrapping is enabled.
local get_jk_mapping = function(key)
  if vim.v.count > 1 then
    return "m'" .. vim.v.count .. key
  end

  local mode = vim.fn.mode()
  if vim.v.count ~= 1 and (mode == 'n' or mode == 'v') then
    return 'g' .. key
  end

  return key
end

-- Improve default behavior of j and k
vim.keymap.set({ 'n', 'x' }, 'j', function()
  return get_jk_mapping 'j'
end, { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', function()
  return get_jk_mapping 'k'
end, { expr = true })

-- Keymap to easily copy text to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy text to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = 'Copy text to system clipboard' })

-- Keymap to delete text without it being put in the clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d', { desc = 'Delete text without yanking it' })
vim.keymap.set({ 'n' }, '<leader>xx', '"_dd', { desc = 'Delete text without yanking it (line)' })

-- Keymap for formatting current paragraph
vim.keymap.set('n', '<leader>.', 'gwip', { desc = 'Reflow text in paragraph' })
vim.keymap.set('x', '<leader>.', 'gw', { desc = 'Reflow text' })

-- Keymap for toggling display of relative line numbers
vim.keymap.set('n', '<leader>tn', '<cmd>set relativenumber!<CR>', { desc = '[T]oggle relative line [n]umbers' })

-- Keymap for switching between light and dark themes
vim.keymap.set('n', '<leader>tl', function()
  if vim.g.is_light_mode then
    vim.cmd.colorscheme(dark_theme)
    vim.g.is_light_mode = false
  else
    vim.cmd.colorscheme(light_theme)
    vim.g.is_light_mode = true
  end
end, { desc = '[T]oggle between [l]ight and dark mode' })

-- Keymap for quickly toggling between tab sizes of 4 and 8 (when using tabs instead of spaces)
vim.keymap.set('n', '<leader>tt', function()
  if vim.o.tabstop == 8 then
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
  else
    vim.o.tabstop = 8
    vim.o.shiftwidth = 8
  end
end, { desc = '[T]oggle between [t]abstop sizes of 4 and 8' })

-- Keymap for toggling line wrap
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle line [w]rap' })

-- Keymap for toggling diagnostics globally
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle [d]iagnostics globally' })

-- Keymap for toggling automatic formatting while editing a paragraph
vim.keymap.set('n', '<leader>tp', function()
  if not string.find(vim.o.formatoptions, 'a', 1, true) then
    -- can't do vim.opt.formatoptions:append { 'a' } as it doesn't work (bug??)
    vim.cmd [[set formatoptions+=a]]
    vim.cmd [[echo 'Automatic paragraph reflow enabled']]
  else
    vim.cmd [[set formatoptions-=a]]
    vim.cmd [[echo 'Automatic paragraph reflow disabled']]
  end
end, { desc = '[T]oggle [p]aragraph reflow' })

-- Keymap to automatically fix currently misspelled word under cursor with first suggestion
vim.keymap.set('n', '<leader>C', '1z=', { desc = 'Auto-fix misspelled word under cursor' })

-- Keymap to help set up a find and replace for the current word under the cursor
vim.keymap.set('n', '<leader>rp', [[:.,$s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = '[R]e[p]lace word from current line onwards' })
vim.keymap.set('n', '<leader>rP', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = '[R]e[p]lace word in buffer' })

-- Remaps to make scroll keys easier to reach
vim.keymap.set({ 'n', 'v' }, '<M-j>', '<c-e>', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<M-k>', '<c-y>', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<M-l>', '<c-d>', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<M-h>', '<c-u>', { remap = true })

-- Keymaps for quickly jumping to the next/previous quickfix item
vim.keymap.set('n', '<M-.>', '<cmd>cnext<CR>', { desc = 'Go to next quickfix item' })
vim.keymap.set('n', '<M-,>', '<cmd>cprev<CR>', { desc = 'Go to previous quickfix item' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Custom Abbreviations ]]

-- Auto-fix misspelled words
vim.cmd [[ab reutnr return]]
vim.cmd [[ab ruetnr return]]
vim.cmd [[ab reutrn return]]
vim.cmd [[ab ruetrn return]]

-- [[ Custom User Commands ]]

-- Add missing :seethe command to complement :cope
vim.api.nvim_create_user_command('Seethe', 'cclose | echo ":seethe"', {})
vim.cmd [[cnoreabbrev seethe Seethe]]

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position when a file is opened
vim.cmd [[
  augroup RestoreCursor
    autocmd!
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ let s:line = line("'\"")
      \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif
  augroup END
]]

-- Persist the chosen colorscheme between sessions
vim.api.nvim_create_autocmd('VimEnter', {
  nested = true,
  callback = function()
    pcall(vim.cmd.colorscheme, vim.g.COLORSCHEME)
  end,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function(params)
    vim.g.COLORSCHEME = params.match
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = false,
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    tag = 'v2.1.0',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>n'] = { name = '[N]eotree', _ = 'which_key_ignore' },
        ['<leader>o'] = { name = '[O]pen', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    -- branch = '0.1.x', -- TODO: switch back when release branch gets mouse support
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

      -- Make it easier to find recently opened files
      'ronandalton/telescope-recent-files.nvim',
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              ['<M-j>'] = 'move_selection_next',
              ['<M-k>'] = 'move_selection_previous', -- overrides results_scrolling_right
              ['<M-l>'] = 'select_default',
              ['<M-;>'] = 'results_scrolling_right', -- alternative for <M-k>
            },
            n = {
              ['<M-k>'] = false, -- to avoid accidental triggering of results_scrolling_right
              ['<M-;>'] = 'results_scrolling_right', -- alternative for <M-k>
            },
          },
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              preview_cutoff = 150,
            },
            flex = {
              flip_columns = 150,
              flip_lines = 40,
            },
          },
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
          },
          file_ignore_patterns = {
            '%.git/',
          },
          history = false,
        },
        pickers = {
          builtin = {
            include_extensions = true,
          },
          buffers = {
            sort_lastused = true,
            sort_mru = true,
          },
          oldfiles = {
            only_cwd = true,
          },
          grep_string = {
            word_match = '-w',
            additional_args = { '--hidden' },
          },
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = { '--hidden' },
          },
          colorscheme = {
            enable_preview = true,
          },
          keymaps = {
            lhs_filter = function(lhs)
              -- Get rid of entries that are which-key <nop> mappings
              return not string.find(lhs, 'Þ')
            end,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          ['recent-files'] = {
            include_current_file = true,
            hidden = true,
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'aerial')
      pcall(require('telescope').load_extension, 'recent-files')
      pcall(require('telescope').load_extension, 'yank_history')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorschemes' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', function()
        builtin.find_files { no_ignore = true }
      end, { desc = '[S]earch [F]iles (no ignore)' })
      vim.keymap.set('n', '<C-p>', require('telescope').extensions['recent-files'].recent_files, { desc = 'Search Files (smart)' })
      vim.keymap.set('n', '<C-S-P>', function()
        require('telescope').extensions['recent-files'].recent_files { no_ignore = true }
      end, { desc = 'Search Files (smart) (no ignore)' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sW', function()
        builtin.grep_string { additional_args = { '--no-ignore' } }
      end, { desc = '[S]earch current [W]ord (no ignore)' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sG', function()
        builtin.live_grep { additional_args = { '--no-ignore' } }
      end, { desc = '[S]earch by [G]rep (no ignore)' })
      vim.keymap.set('n', '<leader>st', builtin.tags, { desc = '[S]earch [T]ags' })
      vim.keymap.set('n', '<leader>sd', function()
        builtin.diagnostics { bufnr = 0 }
      end, { desc = '[S]earch [D]iagnostics (current buffer)' })
      vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics (all buffers)' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'ronandalton/nvim-lspconfig', -- use my custom fork (also changed in typescript-tools.lua,)
    branch = 'custom',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client == nil then
            return
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          end

          -- Find references for the word under your cursor.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          end

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          end

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          end

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          if client.supports_method(vim.lsp.protocol.Methods.workspace_symbol) then
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          end

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          end

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- The following config is needed for the nvim-ufo plugin:
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          capabilities = {
            -- Fix "multiple different client offset_encodings detected" warning
            offsetEncoding = { 'utf-16' },
          },
        },
        -- gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        typos_lsp = {
          init_options = {
            diagnosticSeverity = 'Info',
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'jq', -- Used to format JSON
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            -- Allow disabling LSP for a project.
            -- Example usage: put `let g:disable_lsp = v:true` in the project's .nvimrc file
            if server_name ~= 'typos_lsp' then
              -- NOTE: should_attach option is specific to my fork
              server.should_attach = function()
                return not vim.g.disable_lsp
              end
            else
              server.should_attach = function()
                -- There's no use showing errors you can't fix
                if vim.bo.readonly then
                  return false
                end

                -- Note: disabled for gitcommit files since the builtin spellcheck is used instead
                local ft = vim.bo.filetype
                if ft == 'gitcommit' or ft == 'gitrebase' or ft == 'xxd' or ft == 'toggleterm' then
                  return false
                end

                return true
              end
            end

            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', 'FormatDisable', 'FormatEnable', 'FormatToggle' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_fallback = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), 'v') then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
              end
            end
          end)
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      {
        '<leader>tf',
        function()
          vim.cmd [[FormatToggle]]
        end,
        mode = 'n',
        desc = '[T]oggle [f]ormat on save',
      },
      {
        '<leader>tF',
        function()
          vim.cmd [[FormatToggle!]]
        end,
        mode = 'n',
        desc = '[T]oggle [f]ormat on save (current buffer)',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        json = { 'jq' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })

      vim.api.nvim_create_user_command('FormatToggle', function(args)
        local bufnr = vim.api.nvim_get_current_buf()

        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          vim.cmd [[FormatEnable]]
          vim.cmd [[echo 'Format-on-save enabled']]
        else
          if args.bang then
            vim.cmd [[FormatDisable!]]
            vim.cmd [[echo 'Format-on-save disabled for current buffer']]
          else
            vim.cmd [[FormatDisable]]
            vim.cmd [[echo 'Format-on-save disabled']]
          end
        end
      end, {
        desc = 'Toggle autoformat-on-save',
        bang = true,
      })
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- My alternate mappings
          ['<M-j>'] = cmp.mapping.select_next_item(),
          ['<M-k>'] = cmp.mapping.select_prev_item(),
          ['<M-l>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = cmp.config.sources({
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'

      -- Set global variable used by theme toggle keymap
      vim.g.is_light_mode = false
    end,
    opts = {
      -- Make diff colors more legible.
      -- Assume using 'night' variant of theme.
      on_colors = function(colors)
        colors.diff = {
          add = '#20303b', -- same as default
          change = '#252d55',
          delete = '#37222c', -- same as default
          text = '#2c3a80',
        }
      end,
      on_highlights = function(highlights)
        highlights.LspSignatureActiveParameter = {
          bg = '#3b4261',
          bold = true, -- same as default
        }
      end,
    },
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        custom_textobjects = {
          f = spec_treesitter { a = '@function.outer', i = '@function.inner' },
          c = spec_treesitter { a = '@class.outer', i = '@class.inner' },
        },
        mappings = {
          goto_right = '', -- mini.ai clobbers g] by default, unmap
        },
        n_lines = 500,
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      require('mini.move').setup {
        -- Mappings are set so as to not conflict with the convenience keymaps for scrolling and tmux window switching
        mappings = {
          -- Move visual selection in Visual mode
          left = '',
          right = '',
          down = '<M-S-j>',
          up = '<M-S-k>',

          -- Move current line in Normal mode
          line_left = '',
          line_right = '',
          line_down = '<M-S-j>',
          line_up = '<M-S-k>',
        },
      }

      require('mini.align').setup {}

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        disable = { 'tmux' },
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby', 'php' },
      },
      -- indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },
      -- The following is required to enable integration with the vim-matchup plugin
      matchup = {
        enable = true,
        disable = { 'c', 'cpp', 'ruby' },
        disable_virtual_text = true,
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@class.outer',
            [']]'] = '@function.outer',
          },
          goto_next_end = {
            [']M'] = '@class.outer',
            [']['] = '@function.outer',
          },
          goto_previous_start = {
            ['[m'] = '@class.outer',
            ['[['] = '@function.outer',
          },
          goto_previous_end = {
            ['[M'] = '@class.outer',
            ['[]'] = '@function.outer',
          },
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  dev = {
    path = vim.fn.stdpath 'data' .. '/lazy-local',
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  change_detection = {
    notify = false,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
