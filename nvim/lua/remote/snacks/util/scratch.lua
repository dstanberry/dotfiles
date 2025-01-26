---@class remote.snacks.util.scratch
local M = {}

M.select = function()
  local items = require("snacks").scratch.list()
  local widths = { 0, 0, 0, 0 }

  if not items or #items == 0 then return Snacks.scratch.open() end
  for _, item in ipairs(items) do
    item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
    item.branch = item.branch and ("branch:%s"):format(item.branch) or ""
    item.cwd = item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") or ""
    widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
    widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
    widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
    widths[4] = math.max(widths[4], vim.api.nvim_strwidth(item.branch))
  end

  Snacks.picker.pick {
    source = "select",
    items = items,
    layout = {
      preset = "select",
      preview = false,
      layout = { height = math.floor(math.min(vim.o.lines * 0.6 - 10, #items) + 0.5) + 1 },
    },
    win = {
      input = {
        keys = { ["<c-d>"] = { "delete_scratch", mode = { "i", "n" } } },
      },
    },
    actions = {
      confirm = function(picker, item)
        picker:close()
        vim.schedule(
          function() Snacks.scratch.open { icon = item.icon, file = item.file, name = item.name, ft = item.ft } end
        )
      end,
      delete_scratch = function(picker, item)
        if not (picker and item) then return end
        os.remove(item.file)
        ds.info(("Deleted %s scratch file "):format(item.ft))
        picker:close()
        vim.schedule(M.select)
      end,
    },
  }
end

return M
