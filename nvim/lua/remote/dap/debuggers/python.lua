local M = {}

local function initialize(bufnr)
  if M.initialized then return end

  local dap = require "dap"
  local py = require "dap-python"

  local function _method() py.test_method() end
  local function _class() py.test_class() end

  local pypath = ds.has "win32" and { "Scipts", ".exe" } or { "bin", "" }
  local interpreter =
    ds.plugin.get_pkg_path("debugpy", { path = vim.fs.joinpath("venv", pypath[1], "python" .. pypath[2]) })
  local venv_path

  py.setup(interpreter, { console = "integratedTerminal", include_configs = true, pythonPath = interpreter })

  ds.tbl_each({ "env", "venv" }, function(v, _)
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
        console = "integratedTerminal",
        program = "${file}",
        python = vim.fs.joinpath(venv_path, pypath[1], "python" .. pypath[2]),
      },
      {
        type = "debugpy",
        name = "Python: AWS Lambda (workspace venv)",
        request = "launch",
        console = "integratedTerminal",
        code = function()
          local methods = ds.ft.python.get_defs(bufnr, "method")
          local ok, params = pcall(ds.fs.read, "/tmp/env.json", "r")
          local mod = ([=[runpy.run_path("${file}")["%s"](%s)]=]):format("%s", ok and vim.json.encode(params) or "{}")
          return coroutine.create(function(_c)
            if #methods == 1 then return coroutine.resume(_c, methods[1]) end
            vim.ui.select(
              methods,
              { prompt = "Select lambda handler:", format_item = function(item) return item end },
              function(choice) coroutine.resume(_c, choice and { "import runpy", mod:format(choice) } or dap.ABORT) end
            )
          end)
        end,
        python = vim.fs.joinpath(venv_path, pypath[1], "python" .. pypath[2]),
      },
      {
        type = "debugpy",
        name = "Python: Method in File (workspace venv)",
        request = "launch",
        console = "integratedTerminal",
        code = function()
          local methods = ds.ft.python.get_defs(bufnr, "method")
          local mod = [=[runpy.run_path("${file}")["%s"]()]=]
          return coroutine.create(function(_c)
            if #methods == 1 then return coroutine.resume(_c, methods[1]) end
            vim.ui.select(
              methods,
              { prompt = "Select method to debug:", format_item = function(item) return item end },
              function(choice) coroutine.resume(_c, choice and { "import runpy", mod:format(choice) } or dap.ABORT) end
            )
          end)
        end,
        python = vim.fs.joinpath(venv_path, pypath[1], "python" .. pypath[2]),
      },
    }
  end

  vim.keymap.set("n", "<leader>dp", "", { buffer = bufnr, desc = "+dap: python" })
  vim.keymap.set("n", "<leader>dpm", _method, { buffer = bufnr, desc = "python: test method above cursor" })
  vim.keymap.set("n", "<leader>dpc", _class, { buffer = bufnr, desc = "python: test class above cursor" })
end

M.initialized = false

function M.setup()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "python" then
    vim.api.nvim_create_autocmd("FileType", {
      group = ds.augroup "remote.dap.python",
      pattern = "python",
      once = true,
      callback = function(args) initialize(args.buf) end,
    })
  elseif not M.initialized then
    initialize(bufnr)
  end
end

return M
