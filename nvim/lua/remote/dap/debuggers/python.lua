local M = {}

local initialize = function(bufnr)
  local filepath = ds.has "win32" and ds.plugin.get_pkg_path("debugpy", "venv/Scripts/pythonw.exe")
    or ds.plugin.get_pkg_path("debugpy", "venv/bin/python")

  local _method = function() require("dap-python").test_method() end
  local _class = function() require("dap-python").test_class() end

  vim.keymap.set("n", "<leader>dp", "", { buffer = bufnr, desc = "+dap: python" })
  vim.keymap.set("n", "<leader>dpm", _method, { buffer = bufnr, desc = "python: debug method" })
  vim.keymap.set("n", "<leader>dpc", _class, { buffer = bufnr, desc = "python: debug class" })

  require("dap-python").setup(filepath)
end

M.setup = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "python" then
    vim.api.nvim_create_autocmd("FileType", {
      group = ds.augroup "dap_python",
      pattern = "python",
      callback = function(args) initialize(args.buf) end,
    })
  else
    initialize(bufnr)
  end
end

return M
