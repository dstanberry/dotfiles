-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

local should_reload = false
local reloader = function()
  if should_reload then
    local mod = require "util.modules"
    mod.reload "plenary"
    mod.reload "popup"
    mod.reload "telescope"
  end
end

local telescope = require "telescope"
local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local state = require "telescope.actions.state"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end
  state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

-- set default options
telescope.setup {
  defaults = {
    prompt_prefix = " ❯ ",
    selection_caret = " ",
    scroll_strategy = "cycle",
    layout_strategy = "flex",
    sorting_strategy = "descending",
    layout_config = {
      prompt_position = "bottom",
      horizontal = {
        height = { padding = 0.1 },
        width = { padding = 0.06 },
        preview_width = 0.6,
      },
      vertical = {
        height = { padding = 1 },
        width = { padding = 0.05 },
        preview_height = 0.5,
      },
    },
    mappings = {
      i = {
        ["<c-s>"] = actions.select_horizontal,
        ["<c-y>"] = set_prompt_to_entry_value,
        ["jk"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = { theme = "dropdown" },
    grep_string = {
      layout_strategy = "vertical",
      layout_config = { height = 70 },
    },
    help_tags = {
      theme = "ivy",
      layout_config = { height = 60 },
    },
    live_grep = {
      layout_strategy = "vertical",
      layout_config = { height = 70 },
    },
    lsp_code_actions = {
      theme = "cursor",
      previewer = false,
      results_title = false,
    },
    lsp_definitions = {
      theme = "ivy",
    },
    lsp_document_symbols = {
      layout_strategy = "vertical",
    },
    lsp_dynamic_workspace_symbols = {
      layout_strategy = "vertical",
    },
    lsp_references = {
      theme = "ivy",
    },
    lsp_workspace_symbols = {
      layout_strategy = "vertical",
    },
  },
  extensions = {
    fzf = {
      case_mode = "smart_case",
      override_file_sorter = true,
      override_generic_sorter = false,
    },
  },
}

-- load additional extensions
pcall(telescope.load_extension "fzf")

-- list of directory/file patterns to ignore
local ignored = {
  "%.db",
  "%.gpg",
  "%.git",
  "%.gitattributes",
  "git%-crypt",
  "karabiner/assets",
  "node_modules",
}

local M = {}

-- show current buffer list
function M.buffers()
  builtin.buffers {
    prompt_title = "\\ Buffers /",
  }
end

-- search nvim config
function M.find_nvim()
  builtin.find_files {
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
  ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
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
      local modify_depth = function(m)
        return function()
          opts.depth = opts.depth + m
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
  builtin.file_browser(opts)
end

-- search remote plugins
function M.find_plugins()
  builtin.find_files {
    cwd = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data"),
    previewer = false,
    prompt_title = "\\ Nvim Plugins /",
  }
end

-- grep for pattern within directory
function M.grep_string()
  builtin.grep_string {
    search = vim.fn.input "grep: ",
    path_display = { "shorten" },
    prompt_title = "\\ Grep Project /",
  }
end

-- search current buffer
function M.current_buffer()
  builtin.current_buffer_fuzzy_find {
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
      return builtin[k]
    end
  end,
})
