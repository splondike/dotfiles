-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Soft wrap rather than hard wrap
vim.opt.linebreak = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

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
vim.opt.scrolloff = 10

-- How I want indenting to work by default
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

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

-- At least on my OSX setup this takes a while to start up when opening a Python file, blocking the UI.
-- This is perhaps because it's scalling through all my pyenv environments looking for the neovim package.
-- I don't think I'm using any Python vim plugins though, so can just turn it off.
vim.g.loaded_python3_provider = false

-- Just update the edited file in place to avoid breaking file watchers
vim.g.backupcopy = 'yes'

vim.go.title = true
vim.go.titlelen = 500
-- Allow truncation of lock socket paths via RPCPrefixStrip
vim.go.titlestring = 'VIM %-00.20t | %{v:servername}'
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Update buffer title',
  group = vim.api.nvim_create_augroup('update_buffer_title', { clear = true }),
  callback = function()
    local prefix = vim.g.RPCPrefixStrip
    local socket = vim.v.servername

    if not prefix then
      return
    end

    if socket:sub(1, #prefix) == prefix then
      vim.go.titlestring = 'VIM ' .. vim.fn.expand '%-00.20t' .. ' | ' .. socket:sub(#prefix + 1)
    end
  end,
})

-- Don't require enter to be pressed for long messages, but use two lines in case
-- they add a linebreak at the end (so we don't just see the empty line)
vim.opt.cmdheight = 2
vim.opt.messagesopt = 'wait:0,history:500'

-- vim: ts=2 sts=2 sw=2 et
