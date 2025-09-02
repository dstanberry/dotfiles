return {
  { "Bilal2453/luvit-meta", lazy = true },
  { "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
  { "b0o/schemastore.nvim", lazy = true, version = false },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      popup = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
    config = function(_, opts)
      local lsp = require "lazydev.lsp"
      ---@diagnostic disable-next-line: duplicate-set-field
      lsp.update = function(client)
        lsp.assert(client)
        client:notify("workspace/didChangeConfiguration", {
          settings = { Lua = {} },
        })
      end
      require("lazydev").setup(opts)
    end,
  },
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
    -- event = "LazyFile",
    event = "FileType",
    dependencies = { "williamboman/mason.nvim" },
    init = function() vim.lsp.log.set_level(vim.lsp.log_levels.ERROR) end,
    config = function()
      local handlers = require "remote.lsp.handlers"
      local defaults = { capabilities = handlers.get_client_capabilities(), flags = { debounce_text_changes = 150 } }
      local servers = { ---@type remote.lsp.config[]
        cmake = {},
        cssls = { init_options = { provideFormatter = false } },
        docker_compose_language_service = {},
        dockerls = {},
        emmet_language_server = {},
        helm_ls = {},
        html = { init_options = { provideFormatter = false } },
        marksman = { root_markers = { ".marksman.toml", ".git", ".zk" } },
        terraformls = {},
      }

      handlers.setup()
      ds.fs.walk("lsp", function(path, name, type)
        if (type == "file" or type == "link") and name:match "%.lua$" then
          local fname = name:sub(1, -5)
          local mod = assert(loadfile(path))() ---@type remote.lsp.config
          if mod.disabled then return end
          mod.config = vim.tbl_deep_extend("force", defaults, mod.config or {})
          if mod.setup then mod.setup(mod.config) end
          if mod.defer_setup then return end
          servers = vim.tbl_deep_extend("force", servers, { [fname] = mod.config })
        end
      end)
      ds.foreach(servers, function(config, server)
        if not config.capabilities then config = vim.tbl_deep_extend("force", defaults, config.config or {}) end
        vim.lsp.config(server, config)
      end)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = ds.augroup "lspconfig",
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id)) ---@type vim.lsp.Client
          handlers.on_attach(client, args.buf)
        end,
      })
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
