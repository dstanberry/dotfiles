return {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  enabled = true,
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      go = { "goimports", "gofumpt" },
      javascript = { { "prettierd", "prettier" } },
      lua = { "stylua" },
      markdown = { "markdownlint" },
      pgsql = { "sql_formatter" },
      python = { "isort", "black" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      sql = { "sql_formatter" },
      typescript = { { "prettierd", "prettier" } },
      zsh = { "beautysh" },
    },
    format_on_save = function(buf)
      if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then return end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)
    require("conform.formatters.shfmt").args = { "-i", "2", "-ci", "-sr", "-s", "-bn" }
    require("conform.formatters.beautysh").args = { "--indent-size", "2" }

    require("conform.formatters.prettierd").env = function()
      local conf = ("%s/.prettierrc.json"):format(require("util").buffer.get_root())
      return vim.loop.fs_realpath(conf) and { PRETTIERD_DEFAULT_CONFIG = conf } or {}
    end

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.formatting_disabled = true
      else
        vim.g.formatting_disabled = true
      end
      dump "Disabled auto-format on save."
    end, {
      desc = "Conform: Disable auto-format on save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.formatting_disabled = false
      vim.g.formatting_disabled = false
      dump "Enabled auto-format on save."
    end, {
      desc = "Conform: Enable auto-format on save",
    })
  end,
}
