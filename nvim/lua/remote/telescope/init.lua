-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

local should_reload = true
local reloader = function()
  if should_reload then
    local util = require "util"
    util.reload "plenary"
    util.reload "popup"
    util.reload "telescope"
  end
end

local telescope = require "telescope"
local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local layout = require "telescope.actions.layout"
local state = require "telescope.actions.state"
local themes = require "telescope.themes"

local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end
  state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

telescope.setup {
  defaults = {
    prompt_prefix = " ❯ ",
    selection_caret = " ",
    scroll_strategy = "cycle",
    layout_strategy = "flex",
    sorting_strategy = "descending",
    layout_config = {
      -- prompt_position = "bottom",
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
        ["<c-h>"] = layout.toggle_preview,
        ["<c-d>"] = actions.preview_scrolling_down,
        ["<c-f>"] = actions.preview_scrolling_up,
        ["<c-s>"] = actions.select_horizontal,
        ["<c-v>"] = actions.select_vertical,
        ["<c-u>"] = false,
        ["<c-y>"] = set_prompt_to_entry_value,
        ["jk"] = actions.close,
      },
      n = {
        ["<c-h>"] = layout.toggle_preview,
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = { theme = "ivy" },
    grep_string = {
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    help_tags = {
      theme = "ivy",
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
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
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    lsp_document_symbols = { layout_strategy = "vertical" },
    lsp_dynamic_workspace_symbols = { layout_strategy = "vertical" },
    lsp_references = {
      theme = "ivy",
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    lsp_workspace_symbols = { layout_strategy = "vertical" },
  },
  extensions = {
    fzf = has "win32" and {
      case_mode = "smart_case",
      override_file_sorter = true,
      override_generic_sorter = false,
    } or {},
    ["ui-select"] = {
      themes.get_cursor {
        previewer = false,
        results_title = false,
        layout_config = { width = 40 },
      },
    },
  },
}

if has "win32" then
  pcall(telescope.load_extension "fzf")
end
pcall(telescope.load_extension "gh")
pcall(telescope.load_extension "notify")
pcall(telescope.load_extension "ui-select")

c.tele00 = color.darken(c.base0F, 43)

groups.new("TelescopeSelection", { guifg = nil, guibg = c.tele00, gui = "bold", guisp = nil })
groups.new("TelescopeSelectionCaret", { guifg = c.base04, guibg = c.tele00, gui = "bold", guisp = nil })
groups.new("TelescopeMultiSelection", { guifg = c.base0E, guibg = nil, gui = "none", guisp = nil })
groups.new("TelescopeNormal", { guifg = c.base04, guibg = c.base00, gui = nil, guisp = nil })
groups.new("TelescopeBorder", { guifg = c.base07, guibg = c.base00, gui = nil, guisp = nil })
groups.new("TelescopePromptBorder", { guifg = c.base07, guibg = c.base00, gui = nil, guisp = nil })
groups.new("TelescopeResultsBorder", { guifg = c.base07, guibg = c.base00, gui = nil, guisp = nil })
groups.new("TelescopePreviewBorder", { guifg = c.base07, guibg = c.base00, gui = nil, guisp = nil })
groups.new("TelescopeMatching", { guifg = c.base09, guibg = nil, gui = "bold", guisp = nil })
groups.new("TelescopePromptPrefix", { guifg = c.base08, guibg = c.base00, gui = "none", guisp = nil })

local ignored = {
  "%.DAT",
  "%.db",
  "%.git",
  "%.gitattributes",
  "%.gpg",
  "git%-crypt",
  "karabiner/assets",
  "node_modules",
  "ntuser",
}

local M = {}

local meta = setmetatable({}, {
  __index = function(t, k)
    reloader()
    local use_custom, custom = pcall(require, ("remote.telescope.custom.%s"):format(k))

    if M[k] then
      return M[k]
    elseif use_custom then
      rawset(t, k, custom)
      return custom
    else
      return builtin[k]
    end
  end,
})

function M.find_nvim()
  builtin.find_files {
    cwd = vim.fn.stdpath "config",
    hidden = has "win32" and true or false,
    follow = has "win32" and true or false,
    file_ignore_patterns = ignored,
    prompt_title = [[\ Neovim /]],
  }
end

function M.project_files()
  local opts = {
    hidden = has "win32" and true or false,
    follow = has "win32" and true or false,
    file_ignore_patterns = ignored,
    prompt_title = [[\ Project Files /]],
  }
  ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

function M.file_browser()
  local opts
  opts = {
    hidden = has "win32" and true or false,
    follow = has "win32" and true or false,
    sorting_strategy = "ascending",
    prompt_title = [[\ File Browser /]],
    layout_config = {
      prompt_position = "top",
    },
  }
  builtin.file_browser(opts)
end

function M.find_plugins()
  builtin.find_files {
    cwd = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data"),
    previewer = false,
    prompt_title = [[\ Remote Plugins /]],
  }
end

function M.current_buffer()
  builtin.current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = [[\ Find in File /]],
  }
end

function M.grep_string()
  builtin.grep_string {
    search = vim.fn.input "grep: ",
    path_display = { "shorten" },
    prompt_title = [[\ Grep Project /]],
  }
end

function M.grep_last_search()
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
  builtin.grep_string {
    path_display = { "shorten" },
    word_match = "-w",
    search = register,
  }
end

return meta
