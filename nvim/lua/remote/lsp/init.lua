-- vim.lsp.set_log_level "trace"
-- vim.cmd.edit(vim.lsp.get_log_path())

return {
  { "b0o/schemastore.nvim", lazy = true, version = false },
  { "jmederosalvarado/roslyn.nvim", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "mickael-menu/zk-nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local configs = require "lspconfig.configs"
      local handlers = require "remote.lsp.handlers"

      local on_attach = handlers.on_attach
      local client_capabilities = handlers.get_client_capabilities()
      local servers = {
        bashls = {},
        cmake = {},
        cssls = {},
        html = { init_options = { provideFormatter = false } },
      }
      local enabled = {}

      local root = "remote/lsp/servers"
      ds.walk(root, function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          local m = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
          name = name:sub(1, -5)
          local mod = require(root:gsub("/", ".") .. "." .. m)
          local config = vim.F.if_nil(mod.config, {})
          local server_opts = vim.tbl_deep_extend("force", {
            capabilities = client_capabilities,
            flags = { debounce_text_changes = 150 },
            on_attach = on_attach,
          }, config)
          if mod.register_default_config and not configs[name] then configs[name] = { default_config = config } end
          if mod.setup then mod.setup(server_opts) end
          if not mod.defer_setup then servers = vim.tbl_deep_extend("force", servers, { [name] = config }, enabled) end
        end
      end)
      for srv, config in pairs(servers) do
        if config then
          lspconfig[srv].setup(vim.tbl_deep_extend("force", {
            capabilities = client_capabilities,
            flags = { debounce_text_changes = 150 },
            on_attach = on_attach,
          }, config))
        end
      end
      handlers.setup()
    end,
  },
}
