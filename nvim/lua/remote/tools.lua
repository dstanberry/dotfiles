---@diagnostic disable: undefined-field
local c = require("ui.theme").colors
local color = require "util.color"
local icons = require "ui.icons"
local util = require "util"

return {
  { "gennaro-tedesco/nvim-jqx", ft = "json" },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    enabled = true,
    keys = {
      {
        "ff",
        function() require("conform").format { async = true, lsp_fallback = true } end,
        desc = "conform: format document",
      },
    },
    init = function()
      vim.g.conform_slow_formatters = {}
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.conform_formatting_disabled = true
        else
          vim.g.conform_formatting_disabled = true
        end
        dump "Disabled auto-format on save."
      end, {
        desc = "Conform: Disable auto-format on save for this buffer",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.conform_formatting_disabled = false
        vim.g.conform_formatting_disabled = false
        dump "Enabled auto-format on save."
      end, {
        desc = "Conform: Enable auto-format on save for this buffer",
      })
    end,
    opts = function()
      local prettier_conf = ("%s/.prettierrc.json"):format(require("util").buffer.get_root())

      return {
        formatters_by_ft = {
          bash = { "shfmt" },
          go = { "goimports", "gofumpt" },
          html = { { "prettierd", "prettier" } },
          javascript = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          jsonc = { { "prettierd", "prettier" } },
          lua = { "stylua" },
          markdown = { { "prettierd", "prettier" }, "markdownlint", "cbfmt" },
          pgsql = { "sql_formatter" },
          python = { "isort", "injected", "black" },
          -- python = { "isort", "black" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          sql = { "sql_formatter" },
          typescript = { { "prettierd", "prettier" } },
          yaml = { "yamlfmt" },
          zsh = { "shfmt" },
        },
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2", "-ci", "-sr", "-s", "-bn" },
          },
          prettierd = {
            env = vim.uv.fs_realpath(prettier_conf) and { PRETTIERD_DEFAULT_CONFIG = prettier_conf } or nil,
          },
        },
        format_on_save = function(buf)
          if vim.g.conform_formatting_disabled or vim.b[buf].conform_formatting_disabled then return end
          if vim.g.conform_slow_formatters[vim.bo[buf].filetype] then return end

          local on_format = function(err)
            if err and err:match "timeout$" then vim.g.conform_slow_formatters[vim.bo[buf].filetype] = true end
          end

          vim.api.nvim_exec_autocmds("User", { pattern = "FormatPre" })

          return { timeout_ms = 500, lsp_fallback = true }, on_format
        end,
        format_after_save = function(buf)
          if not vim.g.conform_slow_formatters[vim.bo[buf].filetype] then return end
          return { lsp_fallback = true }
        end,
      }
    end,
  },
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
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        markdown = { "markdownlint" },
        python = { "flake8" },
        sh = { "shellcheck" },
      },
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
    config = function(_, opts)
      local lint = require "lint"
      local M = {}

      lint.linters_by_ft = opts.linters_by_ft

      M.lint = function()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        if #names == 0 then vim.list_extend(names, lint.linters_by_ft["_"] or {}) end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fs.dirname(ctx.filename)
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then dump("Linter not found: " .. name) end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        if #names > 0 then lint.try_lint(names) end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = util.debounce(M.lint, 100),
      })
    end,
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    keys = {
      {
        "<leader>sc",
        function()
          local _, range = util.buffer.get_visual_selection()
          local left = range[1][1] or 1
          local right = range[2][1] or 1
          vim.cmd { cmd = "Silicon", range = { left + 1, right + 1 } }
        end,
        mode = "v",
        desc = "silicon: screenshot selection",
      },
    },
    opts = {
      disable_defaults = false,
      debug = false,
      command = "silicon",
      font = "CartographCF Nerd Font=30",
      background = color.blend(c.purple1, c.bg2, 0.44),
      theme = "kdark",
      line_offset = function(args) return args.line1 end,
      window_title = function() return vim.fs.basename(vim.api.nvim_buf_get_name(0)) end,
    },
    config = function(_, opts) require("silicon").setup(opts) end,
  },
  {
    -- seamless navigation between tmux | neovim splits
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<a-h>", function() require("smart-splits").resize_left(1) end, desc = "smart-splits: resize left" },
      { "<a-j>", function() require("smart-splits").resize_down(1) end, desc = "smart-splits: resize down" },
      { "<a-k>", function() require("smart-splits").resize_up(1) end, desc = "smart-splits: resize up" },
      { "<a-l>", function() require("smart-splits").resize_right(1) end, desc = "smart-splits: resize right" },
      -- moving between splits
      {
        "<c-h>",
        function() require("smart-splits").move_cursor_left() end,
        desc = "smart-splits: move to left window",
      },
      {
        "<c-j>",
        function() require("smart-splits").move_cursor_down() end,
        desc = "smart-splits: move to lower window",
      },
      { "<c-k>", function() require("smart-splits").move_cursor_up() end, desc = "smart-splits: move to upper window" },
      {
        "<c-l>",
        function() require("smart-splits").move_cursor_right() end,
        desc = "smart-splits: move to right window",
      },
      -- swapping buffers between windows
      {
        "<localleader><localleader>h",
        function() require("smart-splits").swap_buf_left() end,
        desc = "smart-splits: swap with left window",
      },
      {
        "<localleader><localleader>j",
        function() require("smart-splits").swap_buf_down() end,
        desc = "smart-splits: swap with lower window",
      },
      {
        "<localleader><localleader>k",
        function() require("smart-splits").swap_buf_up() end,
        desc = "smart-splits: swap with upper window",
      },
      {
        "<localleader><localleader>l",
        function() require("smart-splits").swap_buf_right() end,
        desc = "smart-splits: swap with right window",
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    event = "VeryLazy",
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "tpope/vim-dadbod",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      {
        "<localleader>de",
        function() vim.cmd.edit "~/.local/share/db_ui/connections.json" end,
        desc = "dadbod: edit database connections",
      },
      { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1

      local ftplugin = vim.api.nvim_create_augroup("hl_dadbod", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = ftplugin,
        pattern = { "dbout", "dbui" },
        callback = function()
          vim.opt_local.winhighlight = "Normal:NormalSB"
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
    config = function()
      if require("lazy.core.config").plugins["nvim-cmp"] ~= nil then
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("db-completion", { clear = true }),
          pattern = { "sql", "mysql", "plsql" },
          callback = function()
            ---@diagnostic disable-next-line: missing-fields
            require("cmp").setup.buffer {
              sources = {
                { name = "vim-dadbod-completion" },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer", keyword_length = 5, max_item_count = 5 },
              },
            }
          end,
        })
      end
    end,
  },
}
