local M = {}

M.config = {
  before_init = function(_, config)
    local ok, Path = pcall(require, "plenary.path")
    if ok then
      local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
      if venv:joinpath("bin"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
      elseif has "win32" and venv:joinpath("Scripts"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
      end
      require("remote.dap.debuggers.python").setup(config.settings.python.pythonPath)
    end
  end,
  settings = {
    python = {
      autoImportCompletions = true,
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      -- extraPaths = { "src", "/src" },
    },
  },
}

return M
