---------------------------------------------------------------
-- => markdown linter
---------------------------------------------------------------
return {
  lintCommand = "markdownlint --stdin",
  lintStdin = true,
  lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'},
  lintIgnoreExitCode = true
}
