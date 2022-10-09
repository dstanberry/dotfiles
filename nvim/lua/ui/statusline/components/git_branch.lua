local has_plenary, Job = pcall(require, "plenary.job")
local has_signs, _ = pcall(require, "gitsigns")

local icons = require "ui.icons"

local GIT_ENABLED = setting_enabled "git"

local M = require("ui.statusline.components._class"):extend()

local show_buffer_info = function(bufnr)
  local icon = pad(icons.misc.Orbit, "right")
  for i, b in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr == b then
      return icon, i
    end
  end
end

local show_paste_mode = function()
  local result = ""
  local paste = vim.go.paste
  if paste then
    result = pad(icons.misc.Clipboard, "right")
  end
  return result
end

function M:load()
  local icon = pad(icons.git.Branch, "right")
  local ok, branch
  if GIT_ENABLED then
    if has_signs then
      branch = vim.b.gitsigns_head
      if not branch or #branch == 0 then
        icon, branch = show_buffer_info(self.options.buf)
      end
    elseif has_plenary then
      local j = Job:new {
        command = "git",
        args = { "branch", "--show-current" },
        cwd = vim.fn.fnamemodify(self.options.name, ":h"),
      }
      ok, branch = pcall(function()
        return vim.trim(j:sync()[1])
      end)
      if not ok then
        icon, branch = show_buffer_info(self.options.buf)
      end
    else
      branch = vim.trim(vim.fn.system "git branch --show-current")
      if not branch or #branch == 0 then
        icon, branch = show_buffer_info(self.options.buf)
      end
    end
  end
  if not (ok or branch) then
    icon, branch = show_buffer_info(self.options.buf)
  end
  local p = show_paste_mode()
  if #p > 0 then
    icon = p
  end
  self.label = icon .. branch
end

return M
