local icons = require "ui.icons"

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason-lspconfig.nvim",
        opts = { automatic_installation = true },
      },
    },
    cmd = "Mason",
    opts = {
      PATH = "append",
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      ui = {
        check_outdated_packages_on_open = true,
        border = "none",
        icons = {
          package_installed = icons.misc.CheckFilled,
          package_pending = icons.misc.RightArrowCircled,
          package_uninstalled = icons.misc.Circle,
        },
        keymaps = {
          toggle_package_expand = "<cr>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "C",
          uninstall_package = "X",
          cancel_installation = "<c-c>",
          apply_language_filter = "<c-f>",
        },
      },
    },
  },
}
