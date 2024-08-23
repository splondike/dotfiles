local builtin = require 'telescope.builtin'
local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local make_entry = require 'telescope.make_entry'

local function search_notes(opts)
  local function notes_finder(prompt)
    return {
      'Hello',
      'There',
      prompt,
    }
  end
  pickers
    .new(opts, {
      prompt_title = 'Search notes',
      -- finder = finders.new_job(notes_finder, make_entry.gen_from_string {}, 10, '/'),
      finder = finders.new_table {
        results = { 'red', 'green', 'blue' },
      },
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

-- Docs: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#first-picker
-- vim.keymap.set('n', '<leader>tna', search_notes, { desc = 'Search Notes' })
-- search_notes {}

vim.keymap.set('n', '<leader>tnf', function(opts)
  if not opts then
    opts = {}
  end
  opts.cwd = vim.g.TelescopeNotesDir
  builtin.find_files(opts)
end, { desc = 'Search notes files' })
vim.keymap.set('n', '<leader>tng', function(opts)
  if not opts then
    opts = {}
  end
  opts.cwd = vim.g.TelescopeNotesDir
  builtin.live_grep(opts)
end, { desc = 'Search notes grep' })
