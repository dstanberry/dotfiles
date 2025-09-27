return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {
      PATH = "append",
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      registries = {
        "github:mason-org/mason-registry",
        "lua:remote.mason.registry",
      },
      ui = {
        check_outdated_packages_on_open = true,
        icons = {
          package_installed = ds.icons.misc.CheckFilled,
          package_pending = ds.icons.misc.RightArrowCircled,
          package_uninstalled = ds.icons.misc.Circle,
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
    config = function(_, opts)
      require("mason").setup(opts)
      local mason_registry = require "mason-registry"
      local tools = require "remote.mason.packages" or {}
      local pending = {}
      for _, tool in ipairs(tools) do
        if not mason_registry.is_installed(tool) then table.insert(pending, tool) end
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = vim.schedule_wrap(function()
          vim.opt_local.cursorline = false
          for _, tool in ipairs(pending) do
            local pkg = mason_registry.get_package(tool)
            if not pkg:is_installed() then pkg:install() end
          end
        end),
      })
    end,
  },
}
