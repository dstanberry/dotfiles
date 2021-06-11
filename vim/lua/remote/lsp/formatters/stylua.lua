---------------------------------------------------------------
-- => lua formatter
---------------------------------------------------------------
return {
  formatCommand = "stylua --config-path $XDG_CONFIG_HOME/stylua/stylua.toml -",
  formatStdin = true,
}
