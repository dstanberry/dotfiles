---------------------------------------------------------------
-- => multi-language opinionated formatter
---------------------------------------------------------------
return {
  formatCommand = "prettier --stdin-filepath ${INPUT}"
    .. " --arrow-parens always"
    .. " --end-of-line lf"
    .. " --print-width 80"
    .. " --single-quote false"
    .. " --tab-width 2"
    .. " --trailing-comma es5"
    .. " --use-tabs false",
  formatStdin = true,
}
