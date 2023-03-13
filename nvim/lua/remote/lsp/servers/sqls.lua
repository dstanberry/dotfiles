local pgsql_work = vim.g.config_pgsql_work

local cmd = { "sqls" }
local function get_cmd(root_dir)
  if has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  table.insert(cmd, "-config")
  table.insert(cmd, ("%s/.config.yaml"):format(root_dir))
  return cmd
end

local M = {}

M.config = {
  cmd = cmd,
  on_new_config = function(new_config, new_rootdir) new_config.cmd = get_cmd(new_rootdir) end,
  filetypes = {
    "mysql",
    "pgsql",
    "plsql",
    "sql",
  },
  root_dir = function(_) return require("lspconfig").util.root_pattern ".git" end,
  single_file_support = true,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
    },
    sqls = {
      connections = {
        {
          driver = "postgresql",
          -- dataSourceName = "host=127.0.0.1 port=1234 user=postgres password=secret dbname=pgdb sslmode=disable",
          dataSourceName = pgsql_work or "",
        },
      },
    },
  },
}

vim.api.nvim_create_augroup("lsp_sqls", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp_sqls",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("sqls").on_attach(client, args.buf)
  end,
})

return M
