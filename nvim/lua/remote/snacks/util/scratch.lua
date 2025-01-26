---@class remote.snacks.util.scratch
local M = {}

M.select = function()
  local widths = { 0, 0, 0, 0 }
  local items = require("snacks").scratch.list()
  for _, item in ipairs(items) do
    item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
    item.branch = item.branch and ("branch:%s"):format(item.branch) or ""
    item.cwd = item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") or ""
    widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
    widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
    widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
    widths[4] = math.max(widths[4], vim.api.nvim_strwidth(item.branch))
  end
  require("remote.telescope.util.picker").create("dropdown", items, {
    title = "Select Scratch Buffer",
    mappings = {
      {
        keymap = "<c-d>",
        action = function(bufnr, actions, selection)
          if not (bufnr and actions) then return end
          if selection and selection.value then
            local item = selection.value
            os.remove(item.file)
            ds.info(("Deleted %s scratch file "):format(item.ft))
            actions.close(bufnr)
            vim.schedule(M.select)
          end
        end,
      },
    },
    entry_maker = function(item)
      local parts = { item.cwd, item.icon, item.name, item.branch }
      for i, part in ipairs(parts) do
        parts[i] = part .. string.rep(" ", widths[i] - vim.api.nvim_strwidth(part))
      end
      item.label = table.concat(parts, " ")
      return { ordinal = item.label, display = item.label, value = item }
    end,
    callback = function(selection)
      if selection and selection.value then
        local item = selection.value
        require("snacks").scratch.open { icon = item.icon, file = item.file, name = item.name, ft = item.ft }
      end
    end,
  })
end

return M
