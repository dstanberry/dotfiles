---------------------------------------------------------------
-- => efm-languageserver configuration
---------------------------------------------------------------
-- linter configuration
local eslint = require 'remote.lsp.linters.eslint'
local flake = require 'remote.lsp.linters.flake8'
local markdown = require 'remote.lsp.linters.markdown'
local shellcheck = require 'remote.lsp.linters.shellcheck'
local vint = require 'remote.lsp.linters.vint'

-- formatter configuration
local clang = require 'remote.lsp.formatters.clangformat'
local isort = require 'remote.lsp.formatters.isort'
local luafmt = require 'remote.lsp.formatters.luafmt'
local prettier = require 'remote.lsp.formatters.prettier'
local shfmt = require 'remote.lsp.formatters.shfmt'
local yapf = require 'remote.lsp.formatters.yapf'

-- supported languages
local languages = {
  c = {clang},
  cpp = {clang},
  css = {prettier},
  html = {prettier},
  javascript = {eslint, prettier},
  lua = {luafmt},
  markdown = {markdown, prettier},
  python = {flake, isort, yapf},
  sh = {shellcheck, shfmt},
  vim = {vint},
  yaml = {prettier}
}

return {
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true, codeAction = true},
  settings = {languages = languages, log_level = 1}
}
