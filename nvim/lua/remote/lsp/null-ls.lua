-- verify null-ls is available
local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local M = {}

M.config = null_ls.config {
  debug = false,
  debounce = 150,
  diagnostics_format = "(#{s}) #{m}",
  save_after_format = false,
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.flake8,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.prettierd.with {
      extra_args = {
        "--arrow-parens",
        "always",
        "--end-of-line",
        "lf",
        "--print-width",
        "80",
        "--single-quote",
        "false",
        "--tab-width",
        "2",
        "--trailing-comma",
        "es5",
        "--use-tabs",
        "false",
      },
    },
    null_ls.builtins.formatting.shellcheck,
    null_ls.builtins.formatting.shfmt.with {
      args = { "-i", "2", "-ci", "-sr", "-s", "-bn" },
    },
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.vint,
    null_ls.builtins.formatting.yapf,
  },
}

return M
