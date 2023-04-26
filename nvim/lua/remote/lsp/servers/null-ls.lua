-- verify null-ls is available
local ok, null_ls = pcall(require, "null-ls")
if not ok then return end

local ts_ok, typescript_code_actions = pcall(require, "typescript.extensions.null-ls.code-actions")

local b = null_ls.builtins

local M = {}

local sources = {
  b.code_actions.eslint_d,
  b.code_actions.gitrebase,
  b.code_actions.gitsigns,
  b.code_actions.shellcheck,
  b.diagnostics.eslint_d,
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
    extra_args = { "--config", vim.fs.normalize(("%s/cbfmt.toml"):format(vim.fn.stdpath "config")) },
  },
  b.formatting.eslint_d,
  b.formatting.gofmt,
  b.formatting.prettierd.with {
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

if ts_ok then table.insert(sources, typescript_code_actions) end

M.setup = function(opts)
  null_ls.setup {
    debug = false,
    debounce = 150,
    diagnostics_format = "(#{s}) #{m}",
    save_after_format = false,
    sources = sources,
    on_attach = opts and opts.on_attach and opts.on_attach or {},
  }
end

M.defer_setup = true

return M
