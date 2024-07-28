-- vim.lsp.set_log_level "trace"

return {
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "seblj/roslyn.nvim", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "b0o/schemastore.nvim", lazy = true, version = false },
  { "mickael-menu/zk-nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "williamboman/mason.nvim",
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

      local servers = {
        bashls = {},
        cmake = {},
        cssls = {},
        html = { init_options = { provideFormatter = false } },
        terraformls = {},
      }
      local default_opts = {
        capabilities = handlers.get_client_capabilities(),
        on_attach = handlers.on_attach,
        flags = { debounce_text_changes = 150 },
      }

      local root = "remote/lsp/servers"
      ds.walk(root, function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          local m = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
          name = name:sub(1, -5)
          local mod = require(root:gsub("/", ".") .. "." .. m)
          local mod_enabled = true
          if mod.enabled ~= nil then mod_enabled = mod.enabled end
          local config = vim.F.if_nil(mod.config, {})
          local server_opts = vim.tbl_deep_extend("force", default_opts, config)
          if mod.register_default_config and not configs[name] then configs[name] = { default_config = config } end
          if mod_enabled then
            if mod.setup then mod.setup(server_opts) end
            if not mod.defer_setup then servers = vim.tbl_deep_extend("force", servers, { [name] = config }) end
          end
        end
      end)
      for srv, config in pairs(servers) do
        if config then lspconfig[srv].setup(vim.tbl_deep_extend("force", default_opts, config)) end
      end
      handlers.setup()
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    keys = {
      { "gA", function() require("tiny-code-action").code_action() end, desc = "tiny-code-action: code action" },
    },
    opts = {
      backend = "delta",
      backend_opts = { use_git_config = true },
      telescope_opts = {
        layout_strategy = "vertical",
        layout_config = {
          height = 25,
          preview_height = function(_, _, max_lines)
            local lines = math.floor(max_lines * 0.5)
            return math.max(lines, 10)
          end,
          prompt_position = "bottom",
        },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      blend = { factor = 0.15 },
      options = {
        throttle = 50,
      },
    },
  },
}
