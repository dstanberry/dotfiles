local telescope = require "telescope"
local groups = require "ui.theme.groups"

groups.new("NotifyTRACEBody", { link = "NormalFloat" })
groups.new("NotifyTRACEBorder", { link = "FloatBorder" })
groups.new("NotifyTRACEIcon", { link = "@text" })
groups.new("NotifyTRACETitle", { link = "@text" })

groups.new("NotifyDEBUGBody", { link = "NormalFloat" })
groups.new("NotifyDEBUGBorder", { link = "FloatBorder" })
groups.new("NotifyDEBUGIcon", { link = "Debug" })
groups.new("NotifyDEBUGTitle", { link = "Debug" })

groups.new("NotifyINFOBody", { link = "NormalFloat" })
groups.new("NotifyINFOBorder", { link = "FloatBorder" })
groups.new("NotifyINFOIcon", { link = "String" })
groups.new("NotifyINFOTitle", { link = "String" })

groups.new("NotifyWARNBody", { link = "NormalFloat" })
groups.new("NotifyWARNBorder", { link = "FloatBorder" })
groups.new("NotifyWARNIcon", { link = "WarningMsg" })
groups.new("NotifyWARNTitle", { link = "WarningMsg" })

groups.new("NotifyERRORBody", { link = "NormalFloat" })
groups.new("NotifyERRORBorder", { link = "FloatBorder" })
groups.new("NotifyERRORIcon", { link = "ErrorMsg" })
groups.new("NotifyERRORTitle", { link = "ErrorMsg" })

return {
  "rcarriga/nvim-notify",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    stages = "fade_in_slide_out",
    timeout = 3000,
    background_colour = "Normal",
    render = function(...)
      local n = select(2, ...)
      local style = n.title[1] == "" and "minimal" or "default"
      require("notify.render")[style](...)
    end,
  },
  init = function()
    vim.notify = require "notify"
    telescope.load_extension "notify"
  end,
}
