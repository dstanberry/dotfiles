local l = {
  eslint = {
    lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
  },
  flake = {
    lintCommand = "flake8 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
  },
  markdown = {
    lintCommand = "markdownlint --stdin",
    lintStdin = true,
    lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
    lintIgnoreExitCode = true,
  },
  selene = {
    lintCommand = "selene --config $XDG_CONFIG_HOME/nvim/selene.toml --display-style quiet -",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %tarning%m", "%f:%l:%c: %tarning%m" },
  },
  shellcheck = {
    lintCommand = "shellcheck -f gcc -x -",
    lintStdin = true,
    lintFormats = {
      "%f:%l:%c: %trror: %m",
      "%f:%l:%c: %tarning: %m",
      "%f:%l:%c: %tote: %m",
    },
  },
  vint = {
    lintCommand = "vint --enable-neovim -",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
  },
}

local f = {
  isort = {
    formatCommand = "isort --quiet -",
    formatStdin = true,
  },
  prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}"
      .. " --arrow-parens always"
      .. " --end-of-line lf"
      .. " --print-width 80"
      .. " --single-quote false"
      .. " --tab-width 2"
      .. " --trailing-comma es5"
      .. " --use-tabs false",
    formatStdin = true,
  },
  shfmt = {
    formatCommand = "shfmt -i 2 -ci -sr -s -bn",
    formatStdin = true,
  },
  stylua = {
    formatCommand = "stylua --config-path $XDG_CONFIG_HOME/nvim/stylua.toml -",
    formatStdin = true,
  },
  yapf = {
    formatCommand = "yapf --quiet",
    formatStdin = true,
  },
}

local languages = {
  css = { f.prettier },
  html = { f.prettier },
  javascript = { l.eslint, f.prettier },
  lua = { l.selene, f.stylua },
  markdown = { l.markdown, f.prettier },
  python = { l.flake, f.isort, f.yapf },
  sh = { l.shellcheck, f.shfmt },
  vim = { l.vint },
  yaml = { f.prettier },
}

local M = {}

M.config = {
  filetypes = vim.tbl_keys(languages),
  init_options = {
    documentFormatting = true,
    codeAction = true,
  },
  settings = { languages = languages, log_level = 1 },
}

return M
