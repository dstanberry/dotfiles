local M = {}

local initialize = function(bufnr)
  if not M.initialized then
    M.initialized = true

    local py = require "dap-python"
    local filepath = ds.has "win32" and ds.plugin.get_pkg_path("debugpy", "venv/Scripts/pythonw.exe")
      or ds.plugin.get_pkg_path("debugpy", "venv/bin/python")

    local _method = function() py.test_method() end
    local _class = function() py.test_class() end

    py.setup(filepath, { console = "integratedTerminal", include_configs = true, pythonPath = filepath })

    vim.keymap.set("n", "<leader>dp", "", { buffer = bufnr, desc = "+dap: python" })
    vim.keymap.set("n", "<leader>dpm", _method, { buffer = bufnr, desc = "python: debug method" })
    vim.keymap.set("n", "<leader>dpc", _class, { buffer = bufnr, desc = "python: debug class" })
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
