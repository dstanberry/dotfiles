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
    ssh_aliases = {},
    github_hostname = vim.g.config_github_enterprise_hostname or "github.com",
    picker = "telescope",
  },
}
