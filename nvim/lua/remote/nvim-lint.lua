---@diagnostic disable: undefined-field
local util = require "util"

return {
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
}
