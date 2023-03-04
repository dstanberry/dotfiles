-- verify null-ls is available
local ok, null_ls = pcall(require, "null-ls")
if not ok then return end

local b = null_ls.builtins

local M = {}

local sources = {
  b.code_actions.gitrebase,
  b.code_actions.gitsigns,
  b.diagnostics.flake8,
  b.diagnostics.markdownlint,
  b.diagnostics.shellcheck.with {
    diagnostics_format = "[#{c}] (#{s}) #{m}",
  },
  b.diagnostics.vint,
  b.formatting.beautysh.with {
    filetypes = { "zsh" },
    extra_args = { "--indent-size", "2" },
  },
  b.formatting.black,
  b.formatting.cbfmt.with {
    extra_args = { "--config", vim.fn.expand(("%s/cbfmt.toml"):format(vim.fn.stdpath "config")) },
  },
  b.formatting.eslint_d,
  b.formatting.gofmt,
  b.formatting.prettier.with {
    extra_args = function(params)
      local arguments = {}
      if params.ft == "markdown" then arguments = { "--print-width", "80", "--prose-wrap", "always" } end
      return arguments
    end,
  },
  b.formatting.rustfmt,
  b.formatting.shfmt.with { args = { "-i", "2", "-ci", "-sr", "-s", "-bn" } },
  b.formatting.sql_formatter,
  b.formatting.stylua,
}

M.setup = function(cb)
  null_ls.setup {
    debug = false,
    debounce = 150,
    diagnostics_format = "(#{s}) #{m}",
    save_after_format = false,
    sources = sources,
    on_attach = cb,
  }
end

return M
