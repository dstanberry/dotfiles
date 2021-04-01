---------------------------------------------------------------
-- => Telescope Configuration
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, 'telescope') then
  return
end

-- reload telescope and it's dependencies
local should_reload = true
local reloader = function()
  if should_reload then
    RELOAD('plenary')
    RELOAD('popup')
    RELOAD('telescope')
  end
end
reloader()

-- bring telescope functions into local scope
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')

-- set default options
require('telescope').setup {
  defaults = {
    prompt_prefix = '🔍 ',
    selection_caret = '❯ ',
    winblend = 0,
    preview_cutoff = 120,
    layout_strategy = 'horizontal',
    layout_defaults = {
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = 0.6
      },
      vertical = {
        width_padding = 0.05,
        height_padding = 1,
        preview_height = 0.5
      }
    },
    selection_strategy = "reset",
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    prompt_position = "bottom",
    color_devicons = false,
    mappings = {
      i = {
        ["<C-x>"] = false,
        ["ZZ"] = actions.close,
        ["jk"] = actions.close,
        ["<esc>"] = actions.close,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-q>"] = actions.send_to_qflist
      }
    },
    borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
    file_sorter = sorters.get_fzy_sorter,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new
  },
  extensions = {
    fzy_native = {override_generic_sorter = false, override_file_sorter = true}
  }
}

-- load additional extensions
require('telescope').load_extension('fzy_native')

-- initialize modules table
local M = {}

-- show current buffer list
function M.search_buffers()
  require('telescope.builtin').buffers {shorten_path = false}
end

-- fuzzy search dotfiles from anywhere
function M.search_dotfiles()
  require("telescope.builtin").find_files {
    cwd = "~/.config",
    hidden = true,
    file_ignore_patterns = {
      ".git/", ".gitattributes", ".gitignore", "%.gpg", "%.db",
      "karabiner/assets/*"
    },
    shorten_path = false,
    layout_strategy = 'horizontal',
    prompt_title = "~ dotfiles ~",
    preview_title = false,
    results_title = false
  }
end

-- customize generic fuzzy finder
function M.search_cwd()
  require("telescope.builtin").find_files {
    hidden = true,
    file_ignore_patterns = {
      ".git/", ".gitattributes", ".gitignore", "%.gpg", "%.db",
      "karabiner/assets/*", "node_modules/*"
    },
    shorten_path = false,
    layout_strategy = 'horizontal',
    preview_title = false,
    results_title = false
  }
end

-- customize generic file browser
function M.file_browser()
  require("telescope.builtin").file_browser {
    hidden = true,
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    prompt_position = "top",
    prompt_title = "File Browser",
    preview_title = false,
    results_title = false
  }
end

-- fuzzy search installed vim plugins
function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = "~/.config/vim/remote",
    previewer = false,
    layout_strategy = 'vertical',
    results_title = false
  }
end

-- find occurrences of word under cursor in all files
function M.grep_cursor()
  require("telescope.builtin").grep_string {
    shorten_path = true,
    -- search = vim.fn.input("grep: "),
    prompt_title = "Filter Results",
    preview_title = false,
    results_title = false
  }
end

-- grep for arbitrary pattern in cwd
function M.grep_cwd()
  require("telescope.builtin").find_files {
    find_command = {'rg', '--no-ignore', '--files'},
    prompt_title = "Grep Pattern",
    preview_title = false,
    results_title = false
  }
end

-- fuzzy search tracked files in git repository
function M.git_files()
  require("telescope.builtin").find_files(
    themes.get_dropdown {
      cwd = vim.fn.expand("%:p:h"),
      winblend = 10,
      border = true,
      previewer = false,
      results_title = false
    })
end

-- fuzzy find text within current buffer
function M.current_buffer()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
    prompt_title = "Find in File"
  }
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

-- search help files
function M.help_tags()
  require('telescope.builtin').help_tags {show_version = true}
end

-- call setmetatable whenever any of the custom modules are called
return setmetatable({}, {
  __index = function(_, k)
    reloader()
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})
