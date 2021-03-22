---------------------------------------------------------------
-- => shell program linter
---------------------------------------------------------------
return {
  sourceName = "shellcheck",
  command = "shellcheck",
  debounce = 100,
  args = {"--format", "json", "-"},
  parseJson = {
    line = "line",
    column = "column",
    endLine = "endLine",
    endColumn = "endColumn",
    message = "${message} [${code}]",
    security = "level"
  },
  securities = {
    error = "error",
    warning = "warning",
    info = "info",
    style = "hint"
  }
}
