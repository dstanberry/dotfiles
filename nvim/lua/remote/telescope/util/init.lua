---@class remote.telescope.util
---@field browse remote.telescope.util.browse
---@field files remote.telescope.util.files
---@field grep remote.telescope.util.grep
---@field picker remote.telescope.util.picker
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require(string.format("remote.telescope.util.%s", k))
    return t[k]
  end,
})

function M.collect_all(...)
  local actions = require "telescope.actions"

  if package.loaded["trouble"] then
    return require("trouble.sources.telescope").open(...)
  else
    return actions.send_to_qflist(...) + actions.open_qflist(...)
  end
end

function M.collect_selected(...)
  local actions = require "telescope.actions"

  if package.loaded["trouble"] then
    return require("trouble.sources.telescope").open(...)
  else
    return actions.send_selected_to_qflist(...) + actions.open_qflist(...)
  end
end

function M.copy_commit(prompt_bufnr)
  local actions = require "telescope.actions"
  local state = require "telescope.actions.state"

  local commit = state.get_selected_entry().value
  actions.close(prompt_bufnr)
  vim.fn.setreg("+", commit)
  vim.defer_fn(function() ds.info(("'%s' copied to clipboard"):format(commit), { title = "Telescope" }) end, 500)
end

function M.git_commit_previewer()
  return require("telescope.previewers").new_termopen_previewer {
    get_command = function(entry)
      local shell = ds.has "win32" and "pwsh" or "zsh"
      local flags = ds.has "win32" and "-Command" or "-c"
      return {
        shell,
        flags,
        table.concat({
          "git diff",
          entry.value,
        }, " "),
      }
    end,
  }
end

function M.git_diff_previewer()
  return require("telescope.previewers").new_termopen_previewer {
    get_command = function(entry)
      local shell = ds.has "win32" and "pwsh" or "zsh"
      local flags = ds.has "win32" and "-Command" or "-c"
      local nullpipe = ds.has "win32" and "Nul" or "/dev/null"
      return {
        shell,
        flags,
        table.concat({
          "git diff",
          table.concat { entry.value, "~:", vim.fn.expand "#" },
          table.concat { entry.value, ":", vim.fn.expand "#" },
          "2> " .. nullpipe .. " || git show",
          table.concat { entry.value, ":", vim.fn.expand "#" },
        }, " "),
      }
    end,
  }
end

function M.lsp_symbols_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  local symbols = {
    help = false,
    markdown = false,
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Property",
      "Struct",
      "Trait",
    },
  }
  if symbols[ft] == false then return end
  if type(symbols[ft]) == "table" then return symbols[ft] end
  return symbols.default
end

M.misc = {
  ignore_patterns = {
    "%.DAT",
    "%.db",
    "%.DS_Store",
    "%.git",
    "%.gitattributes",
    "%.gpg",
    "%.venv/",
    "^%.git%-crypt/",
    "^node_modules/",
    "^ntuser",
    "^venv/",
  },
  help_tags = function() require("telescope.builtin").help_tags() end,
  lsp_buffer_diagnostics = function() require("telescope.builtin").diagnostics { bufnr = 0 } end,
  lsp_workspace_diagnostics = function() require("telescope.builtin").diagnostics() end,
}

function M.set_prompt_to_entry_value(prompt_bufnr)
  local state = require "telescope.actions.state"

  local entry = state.get_selected_entry()
  if not entry or not type(entry) == "table" then return end
  state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

function M.switch_focus(prompt_bufnr)
  local actions = require "telescope.actions"
  local state = require "telescope.actions.state"

  local picker = state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local winid = previewer.state.winid
  local bufnr = previewer.state.bufnr
  local _to_prompt = function()
    vim.cmd.lua {
      args = { ("vim.api.nvim_set_current_win(%s)"):format(prompt_win) },
      mods = { noautocmd = true },
    }
  end
  local _close = function() actions.close(prompt_bufnr) end
  vim.keymap.set({ "i", "n" }, "<a-t>", _to_prompt, { buffer = bufnr })
  vim.keymap.set({ "i", "n" }, "q", _close, { buffer = bufnr })
  vim.cmd.lua { args = { ("vim.api.nvim_set_current_win(%s)"):format(winid) }, mods = { noautocmd = true } }
end

return M
