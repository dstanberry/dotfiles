-- verify telescope is available
local ok = pcall(require, "lspconfig")
if not ok and not pcall(require, "telescope") then
  return
end

local should_reload = true
local reloader = function()
  if should_reload then
    reload "plenary"
    reload "popup"
    reload "telescope"
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
local icons = require "ui.icons"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end
  state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

telescope.setup {
  defaults = {
    prompt_prefix = pad(icons.misc.Prompt, "right"),
    selection_caret = pad(icons.misc.CaretRight, "right"),
    scroll_strategy = "cycle",
    layout_strategy = "flex",
    sorting_strategy = "descending",
    results_title = false,
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
    },
    lsp_definitions = {
      theme = "ivy",
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    lsp_document_symbols = {
      layout_strategy = "vertical",
      path_display = { "hidden" },
    },
    lsp_dynamic_workspace_symbols = { layout_strategy = "vertical" },
    lsp_references = {
      path_display = { "shorten" },
      theme = "ivy",
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    lsp_workspace_symbols = {
      layout_strategy = "vertical",
      path_display = { "shorten" },
    },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
    },
    fzf = not has "win32" and {
      case_mode = "smart_case",
      override_file_sorter = true,
      override_generic_sorter = false,
    } or {},
    ["ui-select"] = {
      themes.get_cursor {
        previewer = false,
        layout_config = { width = 40 },
      },
    },
  },
}

if not has "win32" then
  pcall(telescope.load_extension "fzf")
end
pcall(telescope.load_extension "gh")
pcall(telescope.load_extension "notify")
pcall(telescope.load_extension "ui-select")

local GRAY = color.darken(c.gray, 10)
local GRAY_DARK = color.darken(c.gray, 25)
local BLUE = color.darken(c.blue_dark, 43)

groups.new("TelescopePromptBorder", { guifg = GRAY, guibg = GRAY, gui = nil, guisp = nil })
groups.new("TelescopePreviewBorder", { guifg = c.bg_dark, guibg = c.bg_dark, gui = nil, guisp = nil })
groups.new("TelescopeResultsBorder", { guifg = GRAY_DARK, guibg = GRAY_DARK, gui = nil, guisp = nil })

groups.new("TelescopePromptTitle", { guifg = c.gray_light, guibg = nil, gui = "none", guisp = nil })
groups.new("TelescopePreviewTitle", { guifg = c.bg_dark, guibg = nil, gui = "none", guisp = nil })
groups.new("TelescopeResultsTitle", { guifg = GRAY_DARK, guibg = nil, gui = "none", guisp = nil })

groups.new("TelescopePromptPrefix", { guifg = c.green, guibg = GRAY, gui = "none", guisp = nil })
groups.new("TelescopePromptNormal", { guifg = nil, guibg = GRAY, gui = "none", guisp = nil })
groups.new("TelescopePreviewNormal", { guifg = c.green, guibg = c.bg_dark, gui = "none", guisp = nil })
groups.new("TelescopeResultsNormal", { guifg = nil, guibg = GRAY_DARK, gui = "none", guisp = nil })

groups.new("TelescopeMatching", { guifg = c.orange, guibg = nil, gui = "bold", guisp = nil })
groups.new("TelescopeMultiSelection", { guifg = c.magenta, guibg = nil, gui = "none", guisp = nil })
groups.new("TelescopeSelection", { guifg = nil, guibg = BLUE, gui = "bold", guisp = nil })
groups.new("TelescopeSelectionCaret", { guifg = c.fg_dark, guibg = BLUE, gui = "bold", guisp = nil })

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
    file_ignore_patterns = ignored,
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    prompt_title = "Neovim RC Files",
  }
end

function M.project_files()
  local opts = {
    file_ignore_patterns = ignored,
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    prompt_title = "Project Files",
  }
  ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

function M.file_browser()
  local opts
  opts = {
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    prompt_title = "File Browser",
    sorting_strategy = "ascending",
  }
  telescope.extensions.file_browser.file_browser(opts)
end

function M.find_plugins()
  builtin.find_files {
    cwd = string.format("%s/site/pack/packer/", vim.fn.stdpath "data"),
    layout_strategy = "vertical",
    prompt_title = "Remote Plugins",
  }
end

function M.current_buffer()
  builtin.current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = "Find in File",
    sorting_strategy = "ascending",
  }
end

function M.grep_string()
  builtin.grep_string {
    path_display = { "shorten" },
    prompt_title = "Grep Project",
    search = vim.fn.input "grep: ",
  }
end

function M.grep_last_search()
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
  builtin.grep_string {
    path_display = { "shorten" },
    search = register,
    word_match = "-w",
  }
end

return meta
