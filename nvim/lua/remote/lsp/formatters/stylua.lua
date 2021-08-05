---------------------------------------------------------------
-- => lua formatter
---------------------------------------------------------------
return {
  formatCommand = "stylua --config-path $XDG_CONFIG_HOME/nvim/stylua.toml -",
  formatStdin = true,
}
