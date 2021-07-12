---------------------------------------------------------------
-- => Statusline Logging
---------------------------------------------------------------
-- logger configuration
return require("plenary.log").new {
  -- name of the plugin that is prepended to log messages
  plugin = "statusline",
  -- should print the output to neovim while running
  use_console = false,
  -- should highlighting be used in console (using echohl)
  highlights = true,
  -- should write to a file
  use_file = true,
  -- minimum log level
  level = "warn",
  -- level configuration
  modes = {
    { name = "trace", hl = "Comment" },
    { name = "debug", hl = "Comment" },
    { name = "info", hl = "None" },
    { name = "warn", hl = "WarningMsg" },
    { name = "error", hl = "ErrorMsg" },
    { name = "fatal", hl = "ErrorMsg" },
  },
  -- can limit the number of decimals displayed for floats
  float_precision = 0.01,
}
