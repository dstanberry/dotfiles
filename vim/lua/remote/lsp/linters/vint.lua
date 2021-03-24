---------------------------------------------------------------
-- => vimscript linter
---------------------------------------------------------------
return {
  lintCommand = "vint --enable-neovim -",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"}
}
