local slow_formatters = {}
local prettier_conf = ("%s/.prettierrc.json"):format(require("util").buffer.get_root())

return {
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
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      go = { "goimports", "gofumpt" },
      html = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
      json = { { "prettierd", "prettier" } },
      jsonc = { { "prettierd", "prettier" } },
      lua = { "stylua" },
      markdown = { "markdownlint", "cbfmt" },
      pgsql = { "sql_formatter" },
      -- python = { "isort", "black", "injected" },
      python = { "isort", "black" },
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
        env = vim.loop.fs_realpath(prettier_conf) and { PRETTIERD_DEFAULT_CONFIG = prettier_conf } or nil,
      },
    },
    format_on_save = function(buf)
      if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then return end
      if slow_formatters[vim.bo[buf].filetype] then return end

      local on_format = function(err)
        if err and err:match "timeout$" then slow_formatters[vim.bo[buf].filetype] = true end
      end

      vim.api.nvim_exec_autocmds("User", { pattern = "FormatPre" })

      return { timeout_ms = 500, lsp_fallback = true }, on_format
    end,
    format_after_save = function(buf)
      if not slow_formatters[vim.bo[buf].filetype] then return end
      return { lsp_fallback = true }
    end,
  },
  init = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.formatting_disabled = true
      else
        vim.g.formatting_disabled = true
      end
      dump "Disabled auto-format on save."
    end, {
      desc = "Conform: Disable auto-format on save for this buffer",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.formatting_disabled = false
      vim.g.formatting_disabled = false
      dump "Enabled auto-format on save."
    end, {
      desc = "Conform: Enable auto-format on save for this buffer",
    })
  end,
}
