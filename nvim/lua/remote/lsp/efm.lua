---------------------------------------------------------------
-- => efm-languageserver configuration
---------------------------------------------------------------
-- linters
local eslint = {
  lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
}

local flake = {
  lintCommand = "flake8 --stdin-display-name ${INPUT} -",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
}

local markdown = {
  lintCommand = "markdownlint --stdin",
  lintStdin = true,
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
  lintIgnoreExitCode = true,
}

local selene = {
  lintCommand = "selene --config $XDG_CONFIG_HOME/nvim/selene.toml --display-style quiet -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %tarning%m", "%f:%l:%c: %tarning%m" },
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x -",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
}

local vint = {
  lintCommand = "vint --enable-neovim -",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
}

-- formatters
local isort = {
  formatCommand = "isort --quiet -",
  formatStdin = true,
}

local prettier = {
  formatCommand = "prettier --stdin-filepath ${INPUT}"
    .. " --arrow-parens always"
    .. " --end-of-line lf"
    .. " --print-width 80"
    .. " --single-quote false"
    .. " --tab-width 2"
    .. " --trailing-comma es5"
    .. " --use-tabs false",
  formatStdin = true,
}

local shfmt = {
  formatCommand = "shfmt -i 2 -ci -sr -s -bn",
  formatStdin = true,
}

local stylua = {
  formatCommand = "stylua --config-path $XDG_CONFIG_HOME/nvim/stylua.toml -",
  formatStdin = true,
}

local yapf = {
  formatCommand = "yapf --quiet",
  formatStdin = true,
}

-- supported languages
local languages = {
  css = { prettier },
  html = { prettier },
  javascript = { eslint, prettier },
  lua = { selene, stylua },
  markdown = { markdown, prettier },
  python = { flake, isort, yapf },
  sh = { shellcheck, shfmt },
  vim = { vint },
  yaml = { prettier },
}

return {
  filetypes = vim.tbl_keys(languages),
  init_options = {
    documentFormatting = true,
    codeAction = true,
  },
  settings = { languages = languages, log_level = 1 },
}
