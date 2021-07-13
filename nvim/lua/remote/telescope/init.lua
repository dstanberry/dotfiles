---------------------------------------------------------------
-- => Telescope Configuration
---------------------------------------------------------------
-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

-- reload telescope and it's dependencies
local should_reload = true
local reloader = function()
  if should_reload then
    RELOAD "plenary"
    RELOAD "popup"
    RELOAD "telescope"
  end
end
reloader()

-- bring telescope functions into local scope
local actions = require "telescope.actions"
local state = require "telescope.actions.state"
local themes = require "telescope.themes"

-- set default options
require("telescope").setup {
  defaults = {
    prompt_prefix = "  ",
    selection_caret = " ",
    winblend = 10,
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    scroll_strategy = "cycle",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "bottom",
      horizontal = {
        width = { padding = 0.06 },
        height = { padding = 0.1 },
        preview_width = 0.6,
      },
      vertical = {
        width = { padding = 0.05 },
        height = { padding = 1 },
        preview_height = 0.5,
      },
    },
    mappings = {
      i = {
        ["<c-s>"] = actions.select_horizontal,
        ["<c-q>"] = actions.send_to_qflist,
        -- ["<esc>"] = actions.close,
        ["jk"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    lsp_handlers = {
      disable = {},
      code_action = {
        telescope = require("telescope.themes").get_dropdown {
          previewer = false,
          results_title = false,
        },
      },
      location = {
        telescope = require("telescope.themes").get_dropdown {
          results_title = false,
        },
      },
      symbol = {
        telescope = require("telescope.themes").get_dropdown {
          results_title = false,
        },
      },
    },
  },
}

-- load additional extensions
-- require('telescope').load_extension('fzy_native')
pcall(require("telescope").load_extension "fzf")
pcall(require("telescope").load_extension "lsp_handlers")

-- list of directory/file patterns to ignore
local ignored = {
  "%.db",
  "%.gpg",
  ".git/",
  ".gitattributes",
  ".git-crypt/",
  "karabiner/assets/*",
  "node_modules/*",
}

-- initialize modules table
local M = {}

-- show current buffer list
function M.search_buffers()
  require("telescope.builtin").buffers(themes.get_dropdown {
    prompt_title = "\\ Buffers /",
  })
end

-- fuzzy search dotfiles from anywhere
function M.search_dotfiles()
  local opts = {
    cwd = "~/.config",
    hidden = true,
    file_ignore_patterns = ignored,
    prompt_title = "\\ Dotfiles /",
  }
  require("telescope.builtin").find_files(opts)
end

-- customize generic fuzzy finder
function M.search_cwd()
  local opts = {
    hidden = true,
    file_ignore_patterns = ignored,
    prompt_title = "\\ Project Files /",
  }
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

-- customize generic file browser
function M.file_browser()
  local opts
  opts = {
    hidden = true,
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    prompt_position = "top",
    prompt_title = "\\ File Browser /",
    attach_mappings = function(prompt_bufnr, map)
      local current_picker = state.get_current_picker(prompt_bufnr)
      local modify_cwd = function(new_cwd)
        current_picker.cwd = new_cwd
        current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
      end
      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)
      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)
      local modify_depth = function(mod)
        return function()
          opts.depth = opts.depth + mod
          current_picker = state.get_current_picker(prompt_bufnr)
          current_picker:refresh(opts.new_finder(current_picker.cwd), {
            reset_prompt = true,
          })
        end
      end
      map("i", "<right>", modify_depth(1))
      map("i", "<left>", modify_depth(-1))
      return true
    end,
  }
  require("telescope.builtin").file_browser(opts)
end

-- fuzzy search installed vim plugins
function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data"),
    previewer = false,
    prompt_title = "\\ (N)Vim Plugins /",
  }
end

-- find occurrences of word under cursor in all files
function M.grep_cursor()
  require("telescope.builtin").grep_string {
    -- search = vim.fn.input("grep: "),
    prompt_title = "\\ Grep File /",
  }
end

-- grep for arbitrary pattern in cwd
function M.grep_cwd()
  require("telescope.builtin").grep_string {
    search = vim.fn.input "grep: ",
    prompt_title = "\\ Grep Project /",
  }
end

-- fuzzy find text within current buffer
function M.current_buffer()
  require("telescope.builtin").current_buffer_fuzzy_find(themes.get_dropdown {
    previewer = false,
    prompt_title = "\\ Find in File /",
  })
end

-- search help files
function M.help_tags()
  require("telescope.builtin").help_tags { show_version = true }
end

-- call setmetatable whenever any of the custom modules are called
return setmetatable({}, {
  __index = function(_, k)
    reloader()
    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
