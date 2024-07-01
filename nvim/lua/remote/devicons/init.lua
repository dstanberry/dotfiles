return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    local devicons = require "nvim-web-devicons"
    local mine = require "remote.devicons.icons"
    devicons.setup {
      default = false,
      -- this currently won't work because `loaded` cannot be reset
      override = mine,
    }
    devicons.set_default_icon(ds.icons.documents.File, "#6d8086")
    for key, value in pairs(mine) do
      devicons.set_icon { [key] = value }
    end
  end,
}
