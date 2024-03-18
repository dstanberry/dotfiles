local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

groups.new("OctoBubble", { link = "Normal" })
groups.new("OctoEditable", { fg = c.white, bg = color.darken(c.gray0, 10) })

return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Octo",
  keys = {
    { "<leader>go", function() vim.cmd "Octo" end, desc = "octo: manage github issues and pull requests " },
  },
  opts = {
    use_local_fs = false,
    enable_builtin = true,
    default_to_projects_v2 = false,
    ssh_aliases = {},
    github_hostname = vim.g.config_github_enterprise_hostname or "github.com",
    picker = "telescope",
  },
}
