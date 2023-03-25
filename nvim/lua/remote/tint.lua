local function any(target, list)
  for _, item in ipairs(list) do
    if target:match(item) then return true end
  end
  return false
end

local disabled_filetypes = require("remote.lualine.filetypes").stl_disabled
  or {
    "lazy",
    "diff",
    "help",
    "toggleterm",
    "Neogit.*",
    "Telescope.*",
  }

return {
  "levouh/tint.nvim",
  event = "WinNew",
  opts = {
    tint = -10,
    highlight_ignore_patterns = {
      "Bqf.*",
      "Comment",
      "NeoTree.*",
      "Panel.*",
      "St.*",
      "Telescope.*",
      "WinSeparator",
    },
    window_ignore_function = function(win_id)
      if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= "" then return true end
      local buf = vim.api.nvim_win_get_buf(win_id)
      local b = vim.bo[buf]
      local ignore_bt = { "terminal", "prompt", "nofile" }
      local ignore_ft = disabled_filetypes
      return any(b.bt, ignore_bt) or any(b.ft, ignore_ft)
    end,
  },
}
