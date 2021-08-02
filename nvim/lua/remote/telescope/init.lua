---------------------------------------------------------------
-- => Telescope Configuration
---------------------------------------------------------------
-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

-- reload modules
local should_reload = true
local reloader = function()
  if should_reload then
    R "plenary"
    R "popup"
    R "telescope"
  end
end
reloader()

local actions = require "telescope.actions"
local state = require "telescope.actions.state"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end
  state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

-- set default options
require("telescope").setup {
  defaults = {
    prompt_prefix = " ❯ ",
    selection_caret = " ",
    winblend = 10,
    scroll_strategy = "cycle",
    layout_strategy = "flex",
    sorting_strategy = "descending",
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
        ["<c-y>"] = set_prompt_to_entry_value,
        -- ["<esc>"] = actions.close,
        ["jk"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = { theme = "dropdown" },
    grep_string = { theme = "ivy" },
    help_tags = { theme = "ivy" },
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
        telescope = require("telescope.themes").get_cursor {
          previewer = false,
          results_title = false,
        },
      },
      location = {
        telescope = require("telescope.themes").get_ivy {
          results_title = false,
        },
      },
      symbol = {
        telescope = require("telescope.themes").get_ivy {
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
  "^.git$",
  ".gitattributes",
  ".git-crypt",
  "karabiner/assets",
  "node_modules",
}

-- initialize modules table
local M = {}

-- show current buffer list
function M.buffers()
  require("telescope.builtin").buffers {
    prompt_title = "\\ Buffers /",
  }
end

-- search nvim config
function M.find_nvim()
  require("telescope.builtin").find_files {
    cwd = "~/.config/nvim",
    hidden = true,
    follow = true,
    file_ignore_patterns = ignored,
    prompt_title = "\\ Neovim /",
  }
end

-- search current directory
function M.project_files()
  local opts = {
    hidden = true,
    file_ignore_patterns = ignored,
    prompt_title = "\\ Project Files /",
  }
  ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

-- file browser
function M.file_browser()
  local opts
  opts = {
    hidden = true,
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
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

-- search remote plugins
function M.find_plugins()
  require("telescope.builtin").find_files {
    cwd = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data"),
    previewer = false,
    prompt_title = "\\ Nvim Plugins /",
  }
end

-- grep for pattern within directory
function M.grep_string()
  require("telescope.builtin").grep_string {
    search = vim.fn.input "grep: ",
    path_display = { "shorten" },
    prompt_title = "\\ Grep Project /",
  }
end

-- search current buffer
function M.current_buffer()
  require("telescope.builtin").current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = "\\ Find in File /",
  }
end

-- fallback to builtin method if function not defined here
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
