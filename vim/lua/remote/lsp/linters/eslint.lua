---------------------------------------------------------------
-- => javascript linter
---------------------------------------------------------------
return {
  lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
}
