---------------------------------------------------------------
-- => shell program formatter
---------------------------------------------------------------
return {
  formatCommand = "shfmt -i 2 -ci -sr -s -bn",
  formatStdin = true,
}
