return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      popup = { border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end) },
    },
  },
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "seblj/roslyn.nvim", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "b0o/schemastore.nvim", lazy = true, version = false },
  { "mickael-menu/zk-nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
    },
    init = function() vim.lsp.set_log_level(vim.lsp.log_levels.OFF) end,
    config = function()
      local lspconfig = require "lspconfig"
      local configs = require "lspconfig.configs"
      local handlers = require "remote.lsp.handlers"
      local root = "remote/lsp/servers"
      local servers = {
        bashls = {},
        cmake = {},
        cssls = { init_options = { provideFormatter = false } },
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
          local mod = require(root:gsub("/", ".") .. "." .. fname)
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
  {
    "rachartier/tiny-code-action.nvim",
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
          prompt_position = "bottom",
          preview_height = function(_, _, max_lines) return math.max(math.floor(max_lines * 0.5), 10) end,
        },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      blend = { factor = 0.15 },
      options = { throttle = 50 },
    },
  },
}
