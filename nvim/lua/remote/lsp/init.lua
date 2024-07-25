-- vim.lsp.set_log_level "trace"

return {
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "b0o/schemastore.nvim", lazy = true, version = false },
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
  {
    "mickael-menu/zk-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    keys = function()
      local md_keymaps = require "ft.markdown.keymaps"
      local ret = {}
      for k, v in pairs(md_keymaps) do
        table.insert(ret, { k, v[1], desc = v[2], mode = v[3] or "n" })
      end
      return ret
    end,
    opts = {
      name = "zk",
      root_dir = vim.env.ZK_NOTEBOOK_DIR,
    },
    config = function(_, opts)
      local zk = require "zk"
      zk.setup {
        picker = "telescope",
        lsp = { config = opts },
        auto_attach = {
          enabled = false,
          filetypes = { "markdown" },
        },
      }
      vim.api.nvim_create_autocmd("LspAttach", {
        group = ds.augroup "lsp_zk",
        pattern = "*.md",
        callback = function(args)
          if not (args.data and args.data.client_id) then return end
          -- HACK: hijack marksman lsp setup to also add zk to the mix
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "marksman" then require("zk.lsp").buf_add(args.buf) end
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
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
      local enabled = {}

      local root = "remote/lsp/servers"
      ds.walk(root, function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          local m = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
          name = name:sub(1, -5)
          local mod = require(root:gsub("/", ".") .. "." .. m)
          local config = vim.F.if_nil(mod.config, {})
          local server_opts = vim.tbl_deep_extend("force", default_opts, config)
          if mod.register_default_config and not configs[name] then configs[name] = { default_config = config } end
          if mod.setup then mod.setup(server_opts) end
          if not mod.defer_setup then servers = vim.tbl_deep_extend("force", servers, { [name] = config }, enabled) end
        end
      end)
      for srv, config in pairs(servers) do
        if config then lspconfig[srv].setup(vim.tbl_deep_extend("force", default_opts, config)) end
      end
      handlers.setup()
    end,
  },
}
