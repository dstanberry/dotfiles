-- verify vim.ui interface is available
if not vim.ui then
  return
end

local util = require "util"
local icons = require "ui.icons"

local confirm = function(items, on_choice, key)
  local choice = tonumber(vim.fn.expand "<cword>")
  if key then
    choice = key
  end
  vim.api.nvim_win_close(0, true)
  on_choice(items[choice], choice)
end

-- vim.ui.input = function(opts, on_confirm)
--   vim.validate {
--     on_confirm = { on_confirm, "function", false },
--   }
--   opts = opts or {}
--   local lines = {}
--   local title = opts.prompt
--   lines = { title, string.rep(window.separator, 30), unpack(lines) }
--   local bufnr, _ = window.popup_window {
--     width = 30,
--     lines = lines,
--     height = 3,
--     enter = true,
--     input = true,
--     prompt = {
--       enable = true,
--       prefix = icons.misc.Prompt,
--       highlight = "Float",
--     },
--     on_confirm = function()
--       local input = vim.trim(vim.fn.getline("."):sub(#options.prefix + 1, -1))
--       vim.api.nvim_win_close(0, true)
--       on_confirm(input)
--     end,
--   }
--   vim.api.nvim_buf_add_highlight(bufnr, -1, "Title", 0, 0, #title)
--   vim.api.nvim_buf_add_highlight(bufnr, -1, "FloatBorder", 1, 0, -1)
-- end

vim.ui.select = function(items, opts, on_choice)
  vim.validate {
    items = { items, "table", false },
    on_choice = { on_choice, "function", false },
  }
  opts = opts or {}
  local choices = { opts.prompt or "Select one of:" }
  local format_item = opts.format_item or tostring
  for i, item in pairs(items) do
    table.insert(choices, string.format("[%d] %s", i, format_item(item)))
  end
  local title = table.remove(choices, 1)
  local width = util.window.calculate_width(choices)
  choices = { title, string.rep(util.window.separator, width), unpack(choices) }
  local bufnr, _ = util.window.popup_window {
    lines = choices,
    enter = true,
    set_cursor = true,
    on_confirm = function()
      confirm(items, on_choice)
    end,
  }
  vim.api.nvim_buf_add_highlight(bufnr, -1, "Title", 0, 0, #title)
  vim.api.nvim_buf_add_highlight(bufnr, -1, "FloatBorder", 1, 0, -1)
  for k, _ in ipairs(choices) do
    if k > 2 then
      vim.keymap.set("n", string.format("%d", k - 2), function()
        confirm(items, on_choice, k - 2)
      end, { buffer = true })
    end
  end
end
