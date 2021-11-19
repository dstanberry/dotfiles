-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

local should_reload = false
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
    buffers = { theme = "dropdown" },
    grep_string = {
      layout_strategy = "vertical",
      layout_config = { height = 70 },
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
    fzf = {
      case_mode = "smart_case",
      override_file_sorter = true,
      override_generic_sorter = false,
    },
  },
}

pcall(telescope.load_extension "fzf")
pcall(telescope.load_extension "gh")
pcall(telescope.load_extension "notify")

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
  "%.db",
  "%.gpg",
  "%.git",
  "%.gitattributes",
  "git%-crypt",
  "karabiner/assets",
  "node_modules",
}

local M = {}

local meta = setmetatable({}, {
  __index = function(t, k)
    reloader()
    if M[k] then
      return M[k]
    elseif k == "rg" then
      local val = require("remote.telescope.custom.rg")
      rawset(t, k, val)
      return val
    elseif k == "lsp" then
      local val = require("remote.telescope.custom.lsp")
      rawset(t, k, val)
      return val
    else
      return builtin[k]
    end
  end,
})

function M.find_nvim()
  builtin.find_files {
    cwd = "~/.config/nvim",
    hidden = true,
    follow = true,
    file_ignore_patterns = ignored,
    prompt_title = [[\ Neovim /]],
  }
end

function M.project_files()
  local opts = {
    hidden = true,
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
    hidden = true,
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

function M.grep_string()
  builtin.grep_string {
    search = vim.fn.input "grep: ",
    path_display = { "shorten" },
    prompt_title = [[\ Grep Project /]],
  }
end

function M.current_buffer()
  builtin.current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = [[\ Find in File /]],
  }
end

return meta
