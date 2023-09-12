local util = require "util"

-- vim.lsp.set_log_level "trace"
-- vim.cmd.edit(vim.lsp.get_log_path())

local ensure_installed = {
  bashls = {},
  cmake = {},
  cssls = {},
  html = { init_options = { provideFormatter = false } },
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "pmizio/typescript-tools.nvim",
      "simrat39/rust-tools.nvim",
      "williamboman/mason.nvim",
      { "mickael-menu/zk-nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
        config = true,
      },
    },
    config = function()
      local handlers = require "remote.lsp.handlers"
      local on_attach_nvim = handlers.on_attach
      local client_capabilities = handlers.get_client_capabilities()
      local configurations = vim.api.nvim_get_runtime_file("lua/remote/lsp/servers/*.lua", true)
      for _, file in ipairs(configurations) do
        local modname = util.get_module_name(file)
        local mod = require(modname)
        local srv = (modname):match "[^%.]*$"
        local config = vim.F.if_nil(mod.config, {})
        local configs = require "lspconfig.configs"
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config)
        if mod.register_default_config and not configs[srv] then configs[srv] = { default_config = config } end
        if mod.setup then mod.setup(server_opts) end
        if not mod.defer_setup then
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, { [srv] = config })
        end
      end
      for server, config in pairs(ensure_installed) do
        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
      end
      handlers.setup()
    end,
  },
}
