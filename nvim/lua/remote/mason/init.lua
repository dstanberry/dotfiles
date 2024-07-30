return {
  {
    "williamboman/mason.nvim",
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
        border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
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
    init = function()
      ds.hl.new("MasonMutedBlock", { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.bg3 })
      ds.hl.new("MasonHighlightBlockBold", { bg = ds.color.get_color("Visual", true), bold = true })
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      local mason_registry = require "mason-registry"
      local tools = require "remote.mason.packages" or {}
      for _, tool in ipairs(tools) do
        local pkg = mason_registry.get_package(tool)
        if not pkg:is_installed() then pkg:install() end
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function() vim.opt_local.cursorline = false end,
      })
    end,
  },
}
