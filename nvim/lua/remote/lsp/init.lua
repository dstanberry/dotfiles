return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      popup = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
    },
  },
  { "seblj/roslyn.nvim", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "b0o/schemastore.nvim", lazy = true, version = false },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = { blend = { factor = 0.15 }, options = { throttle = 50 } },
  },
  {
    "mickael-menu/zk-nvim",
    enabled = not ds.has "win32",
    dependencies = { "williamboman/mason.nvim" },
    event = (vim.env.ZK_NOTEBOOK_DIR and vim.env.ZK_NOTEBOOK_DIR ~= "")
      and { "BufRead " .. vim.env.ZK_NOTEBOOK_DIR .. "/**/*.md" },
    keys = function()
      local keymap = require "ft.markdown.keymaps"
      local keys = {}
      for k, v in pairs(keymap) do
        table.insert(keys, { k, v[1], desc = v[2] or "", mode = v[3] or "n" })
      end
      return keys
    end,
    opts = {
      picker = "snacks_picker",
      lsp = {
        config = {
          cmd = { "zk", "lsp" },
          name = "zk",
          root_dir = vim.env.ZK_NOTEBOOK_DIR,
        },
      },
      auto_attach = {
        enabled = true,
        filetypes = { "markdown" },
      },
    },
    config = function(_, opts) require("zk").setup(opts) end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = { "williamboman/mason.nvim" },
    init = function() vim.lsp.set_log_level(vim.lsp.log_levels.ERROR) end,
    config = function()
      local lspconfig = require "lspconfig"
      local configs = require "lspconfig.configs"
      local handlers = require "remote.lsp.handlers"
      local root = "remote/lsp/servers"
      local servers = {
        cmake = {},
        cssls = { init_options = { provideFormatter = false } },
        docker_compose_language_service = {},
        dockerls = {},
        helm_ls = {},
        html = { init_options = { provideFormatter = false } },
        terraformls = {},
      }
      local defaults = {
        capabilities = handlers.get_client_capabilities(),
        on_attach = handlers.on_attach,
        flags = { debounce_text_changes = 150 },
      }

      ds.foreach(servers, function(config, s) servers[s] = vim.tbl_deep_extend("force", defaults, config or {}) end)
      handlers.setup()
      ds.fs.walk(root, function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          name = name:sub(1, -5)
          local fname = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
          local mod = require(root:gsub("/", ".") .. "." .. fname) ---@type remote.lsp.config
          if mod.disabled then return end
          if mod.default_config then
            configs[name] = vim.tbl_deep_extend("force", configs[name] or {}, { default_config = mod.default_config })
          end
          mod.config = vim.tbl_deep_extend("force", defaults, mod.config or {})
          if mod.setup then mod.setup(mod.config) end
          if mod.defer_setup then return end
          servers = vim.tbl_deep_extend("force", servers, { [name] = mod.config })
        end
      end)
      ds.foreach(servers, function(config, server) lspconfig[server].setup(config) end)
    end,
  },
}
