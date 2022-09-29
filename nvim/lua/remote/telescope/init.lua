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

local interactive_rebase = function(prompt_bufnr)
  local commit = state.get_selected_entry().value
  actions.close(prompt_bufnr)
  vim.api.nvim_exec("tabnew | terminal", false)
  local term_channel = vim.opt_local.channel:get()
  vim.api.nvim_chan_send(term_channel, ("git rebase --interactive %s\r"):format(commit))
  vim.cmd.normal "a"
end

local copy_commit = function(prompt_bufnr)
  local commit = state.get_selected_entry().value
  actions.close(prompt_bufnr)
  vim.fn.setreg("+", commit)
  vim.defer_fn(function()
    vim.notify(("'%s' copied to clipboard"):format(commit), nil, { timeout = 500 })
  end, 500)
end

telescope.setup {
  defaults = {
    prompt_prefix = pad(icons.misc.Prompt, "right"),
    selection_caret = pad(icons.misc.CaretRight, "right"),
    multi_icon = pad(icons.misc.CaretRight, "right"),
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
        ["<c-d>"] = actions.preview_scrolling_down,
        ["<c-f>"] = actions.preview_scrolling_up,
        ["<c-p>"] = layout.toggle_preview,
        ["<c-t>"] = actions.select_tab,
        ["<c-v>"] = actions.select_vertical,
        ["<c-x>"] = actions.select_horizontal,
        ["<c-y>"] = set_prompt_to_entry_value,
        ["<c-n>"] = false,
        ["<c-u>"] = false,
        ["jk"] = actions.close,
      },
      n = {
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
    git_bcommits = {
      layout_strategy = "vertical",
      layout_config = { height = 70 },
      mappings = {
        i = {
          ["<c-r>"] = interactive_rebase,
          ["<c-y>"] = copy_commit,
        },
      },
    },
    git_commits = {
      layout_strategy = "vertical",
      layout_config = { height = 70 },
      mappings = {
        i = {
          ["<c-r>"] = interactive_rebase,
          ["<c-y>"] = copy_commit,
        },
      },
    },
    diagnostics = {
      path_display = { "shorten" },
      theme = "ivy",
      layout_config = {
        height = 30,
        prompt_position = "top",
      },
    },
    lsp_definitions = {
      theme = "ivy",
      layout_config = {
        height = 60,
        prompt_position = "top",
      },
    },
    lsp_document_symbols = {
      path_display = { "hidden" },
      theme = "ivy",
      layout_config = {
        height = 40,
        prompt_position = "top",
      },
    },
    lsp_dynamic_workspace_symbols = {
      path_display = { "shorten" },
      theme = "ivy",
      layout_config = {
        height = 40,
        prompt_position = "top",
      },
    },
    lsp_references = {
      path_display = { "shorten" },
      theme = "ivy",
      layout_config = {
        height = 40,
        prompt_position = "top",
      },
    },
    lsp_workspace_symbols = {
      path_display = { "shorten" },
      theme = "ivy",
      layout_config = {
        height = 40,
        prompt_position = "top",
      },
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
      },
    },
  },
}

if not has "win32" then
  pcall(telescope.load_extension "fzf")
end
pcall(telescope.load_extension "gh")
pcall(telescope.load_extension "ui-select")

local GRAY = color.darken(c.gray, 10)
local GRAY_DARK = color.darken(c.gray, 25)
local BLUE = color.darken(c.blue_dark, 43)

groups.new("TelescopePromptBorder", { fg = GRAY, bg = GRAY })
groups.new("TelescopePreviewBorder", { fg = c.bg_dark, bg = c.bg_dark })
groups.new("TelescopeResultsBorder", { fg = GRAY_DARK, bg = GRAY_DARK })

groups.new("TelescopePromptTitle", { fg = c.bg, bg = c.red, bold = true })
groups.new("TelescopePreviewTitle", { fg = c.bg_dark })
groups.new("TelescopeResultsTitle", { fg = GRAY_DARK })

groups.new("TelescopePromptCounter", { fg = c.gray_light })
groups.new("TelescopePromptPrefix", { fg = c.green })
groups.new("TelescopePromptNormal", { fg = nil, bg = GRAY })
groups.new("TelescopePreviewNormal", { fg = c.green, bg = c.bg_dark })
groups.new("TelescopeResultsNormal", { fg = nil, bg = GRAY_DARK })

groups.new("TelescopeMatching", { fg = c.orange, bold = true })
groups.new("TelescopeMultiSelection", { fg = c.magenta })
groups.new("TelescopeSelection", { fg = nil, bg = BLUE, bold = true })
groups.new("TelescopeSelectionCaret", { fg = c.fg_dark, bg = BLUE, bold = true })

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
    elseif builtin[k] then
      return builtin[k]
    else
      return telescope[k]
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
    prompt_title = "Project Files (Git)",
  }
  if not pcall(builtin.git_files, opts) then
    opts.prompt_title = "Project Files"
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

function M.file_browser_relative()
  local opts
  opts = {
    path = "%:p:h",
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
