---------------------------------------------------------------
-- => lua formatter
---------------------------------------------------------------
return {
  formatCommand = "lua-format -i --column-limit=80 --indent-width=2" ..
    " --continuation-indent-width=2" .. " --no-keep-simple-function-one-line" ..
    " --no-keep-simple-control-block-one-line",
  formatStdin = true
}
