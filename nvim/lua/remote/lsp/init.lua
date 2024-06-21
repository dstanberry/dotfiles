-- vim.lsp.set_log_level "trace"
-- vim.cmd.edit(vim.lsp.get_log_path())

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      -- INFO: utilities
      "b0o/schemastore.nvim",
      "williamboman/mason.nvim",
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
        config = true,
      },
      -- INFO: server configurations
      "jmederosalvarado/roslyn.nvim",
      "simrat39/rust-tools.nvim",
      { "mickael-menu/zk-nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
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
      local enabled = {
        pyright = false,
        tsserver = false,
      }
      local extras = { base = "nvim/lua/", root = "remote/lsp/servers" }
      local start = extras.base .. extras.root
      ds.walk(start, function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          name = path:sub(#start + 2, -5):gsub("/", ".")
          local mod = require(extras.root:gsub("/", ".") .. "." .. name)
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
