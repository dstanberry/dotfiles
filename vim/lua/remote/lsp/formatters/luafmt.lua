---------------------------------------------------------------
-- => lua formatter
---------------------------------------------------------------
return {
  formatCommand = "lua-format -i --column-limit=80 --indent-width=2" ..
    " --continuation-indent-width=2",
  formatStdin = true
}
