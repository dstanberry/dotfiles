local M = {}

local initialize = function(bufnr)
  if not M.initialized then
    M.initialized = true

    local dap = require "dap"
    local py = require "dap-python"

    local _method = function() py.test_method() end
    local _class = function() py.test_class() end

    local pypath = ds.has "win32" and { "Scipts", ".exe" } or { "bin", "" }
    local venv_path
    local interpreter = ds.plugin.get_pkg_path("debugpy", vim.fs.joinpath("venv", pypath[1], "python" .. pypath[2]))
    ds.foreach({ "env", "venv" }, function(v, _)
      if not venv_path then
        venv_path = ds.root.detectors.pattern(bufnr, { v })[1]
        if venv_path then venv_path = vim.fs.joinpath(venv_path, v) end
      end
    end)

    if venv_path then
      dap.configurations.python = {
        {
          type = "debugpy",
          name = "Python: Current File (workspace venv)",
          request = "launch",
          program = "${file}",
          console = "integratedTerminal",
          python = vim.fs.joinpath(venv_path, pypath[1], "python" .. pypath[2]),
        },
      }
    end

    py.setup(interpreter, { console = "integratedTerminal", include_configs = true, pythonPath = interpreter })

    vim.keymap.set("n", "<leader>dp", "", { buffer = bufnr, desc = "+dap: python" })
    vim.keymap.set("n", "<leader>dpm", _method, { buffer = bufnr, desc = "python: test method above cursor" })
    vim.keymap.set("n", "<leader>dpc", _class, { buffer = bufnr, desc = "python: test class above cursor" })
  end
end

M.initialized = false

M.setup = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "python" then
    vim.api.nvim_create_autocmd("FileType", {
      group = ds.augroup "dap_python",
      pattern = "python",
      once = true,
      callback = function(args) initialize(args.buf) end,
    })
  elseif not M.initialized then
    initialize(bufnr)
  end
end

return M
