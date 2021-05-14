---------------------------------------------------------------
-- => clang formatter
---------------------------------------------------------------
return {
  formatCommand = "clang-format -i --style='{BasedOnStyle:llvm, IndentWidth: 2}'",
  formatStdin = true
}
