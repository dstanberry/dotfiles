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
    ensure_installed = {
      "angular-language-server",
      "bash-language-server",
      "beautysh",
      "black",
      "cbfmt",
      "clangd",
      "cmake-language-server",
      "codelldb",
      "css-lsp",
      "delve",
      "eslint-lsp",
      "eslint_d",
      "flake8",
      "gofumpt",
      "goimports",
      "gopls",
      "html-lsp",
      "isort",
      "js-debug-adapter",
      "json-lsp",
      "lua-language-server",
      "markdownlint",
      "marksman",
      "netcoredbg",
      "prettier",
      "prettierd",
      "pyright",
      "rust-analyzer",
      "shellcheck",
      "shfmt",
      "snyk-ls",
      "sql-formatter",
      "stylua",
      "typescript-language-server",
      "vale",
      "vim-language-server",
      "vint",
      "yaml-language-server",
      "yamlfmt",
    },
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
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mason_registry = require "mason-registry"
      for _, tool in ipairs(plugin.ensure_installed) do
        local pkg = mason_registry.get_package(tool)
        if not pkg:is_installed() then pkg:install() end
      end
    end,
  },
}
