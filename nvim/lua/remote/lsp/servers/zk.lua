local M = {}

M.defer_setup = true

M.setup = function(opts)
  local ok, zk = pcall(require, "zk")
  if not ok then return end

  require "ft.markdown.keymaps"

  zk.setup {
    picker = "telescope",
    lsp = { config = opts },
    auto_attach = {
      enabled = false,
      filetypes = { "markdown" },
    },
  }
  local lsp_zk = vim.api.nvim_create_augroup("lsp_zk", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_zk,
    pattern = "*.md",
    callback = function(args)
      if not (args.data and args.data.client_id) then return end
      -- HACK: hijack marksman lsp setup to also add zk to the mix
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "marksman" then require("zk.lsp").buf_add(args.buf) end
    end,
  })
end

M.config = {
  name = "zk",
  root_dir = vim.env.ZK_NOTEBOOK_DIR,
}

return M
