---------------------------------------------------------------
-- => lua linter
---------------------------------------------------------------
return {
  lintCommand = "selene --config $XDG_CONFIG_HOME/nvim/selene.toml --display-style quiet -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %tarning%m", "%f:%l:%c: %tarning%m" },
}
