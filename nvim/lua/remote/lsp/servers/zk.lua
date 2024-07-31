local M = {}

M.enabled = not ds.has "win32"

M.initialized = false

local init_zk = function()
  if M.initialized then return end
  M.initialized = true
  require("zk").setup {
    picker = "telescope",
    lsp = {
      config = {
        name = "zk",
        root_dir = vim.env.ZK_NOTEBOOK_DIR,
      },
    },
    auto_attach = {
      enabled = false,
      filetypes = { "markdown" },
    },
  }
end

M.defer_setup = true

M.setup = function()
  local md_keymaps = require "ft.markdown.keymaps"
  for k, v in pairs(md_keymaps) do
    local _func = function()
      init_zk()
      v[1]()
    end
    vim.keymap.set(v[3] or "n", k, _func, { desc = v[2] or "" })
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    group = ds.augroup "lsp_zk",
    pattern = "*.md",
    callback = function(args)
      if not (args.data and args.data.client_id) then return end
      -- HACK: hijack marksman lsp setup to also add zk to the mix
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "marksman" then
        init_zk()
        require("zk.lsp").buf_add(args.buf)
      end
    end,
  })
end

return M
