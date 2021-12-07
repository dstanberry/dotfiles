-- verify null-ls is available
local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local M = {}

local sources = {
  null_ls.builtins.code_actions.gitsigns,
  null_ls.builtins.diagnostics.flake8,
  null_ls.builtins.diagnostics.markdownlint,
  null_ls.builtins.diagnostics.shellcheck.with {
    diagnostics_format = "[#{c}] (#{s}) #{m}",
  },
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.formatting.eslint_d,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.prettier.with {
    extra_args = function(params)
      return params.ft == "markdown" and { "$FILENAME", "--print-width", "80", "--prose-wrap", "always" }
        or { "$FILENAME" }
    end,
  },
  null_ls.builtins.formatting.shfmt.with { args = { "-i", "2", "-ci", "-sr", "-s", "-bn" } },
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.yapf,
}

M.config = null_ls.config {
  debug = false,
  debounce = 150,
  diagnostics_format = "(#{s}) #{m}",
  save_after_format = false,
  sources = sources,
}

return M
