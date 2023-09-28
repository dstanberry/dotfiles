return {
  "mfussenegger/nvim-lint",
  event = "BufReadPre",
  config = function()
    local lint = require "lint"
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      markdown = { "markdownlint" },
      python = { "flake8" },
      sh = { "shellcheck" },
    }

    local conf = ("%s/.markdownlint.json"):format(require("util").buffer.get_root())
    lint.linters.markdownlint.args = vim.loop.fs_realpath(conf) and { "--config", conf } or { "--disable", "MD013" }

    local diagnose = function()
      local diag = vim.diagnostic.get(0, { severity_limit = vim.diagnostic.severity.WARN })
      if diag and type(diag) == "table" and #diag > 0 then return end
      lint.try_lint()
    end

    local ext_diagnostic = vim.api.nvim_create_augroup("ext_diagnostic", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter,BufRead", {
      group = ext_diagnostic,
      pattern = { "*" },
      callback = function(opts)
        opts = opts or {}
        opts.id = nil
        vim.defer_fn(function() diagnose() end, 300)
      end,
    })

    vim.api.nvim_create_autocmd("TextChanged", {
      group = ext_diagnostic,
      pattern = { "*" },
      callback = function(opts)
        opts = opts or {}
        opts.id = nil
        diagnose()
      end,
    })
  end,
}
