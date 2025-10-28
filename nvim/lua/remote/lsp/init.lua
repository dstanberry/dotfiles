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
      ds.tbl_each(keymap, function(v, k) table.insert(keys, { k, v[1], desc = v[2] or "", mode = v[3] or "n" }) end)
      return keys
    end,
    opts = {
      picker = "snacks_picker",
      lsp = { config = { cmd = { "zk", "lsp" }, name = "zk", root_dir = vim.env.ZK_NOTEBOOK_DIR } },
      auto_attach = { enabled = true, filetypes = { "markdown" } },
    },
    config = function(_, opts) require("zk").setup(opts) end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = { "williamboman/mason.nvim" },
    init = function() vim.lsp.log.set_level(vim.lsp.log_levels.ERROR) end,
    opts = {
      capabilities = { ---@type lsp.ClientCapabilities
        workspace = {
          fileOperations = { didRename = true, willRename = true },
        },
      },
      diagnostics = { ---@type vim.diagnostic.Opts
        severity_sort = true,
        update_in_insert = false,
        virtual_text = false,
        underline = { severity = { min = vim.diagnostic.severity.WARN } },
        float = {
          focusable = false,
          show_header = true,
          source = true,
        },
        jump = {
          on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = "cursor", focus = false } end,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ds.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = ds.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = ds.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = ds.icons.diagnostics.Info,
          },
        },
      },
      servers = { ---@type remote.lsp.config[]
        cmake = {},
        cssls = { init_options = { provideFormatter = false } },
        docker_compose_language_service = {},
        dockerls = {},
        emmet_language_server = {},
        gh_actions_ls = {},
        helm_ls = {},
        html = { init_options = { provideFormatter = false } },
        marksman = { root_markers = { ".marksman.toml", ".git", ".zk" } },
        terraformls = {},
      },
    },
    config = vim.schedule_wrap(function(_, opts)
      local handlers = require "remote.lsp.handlers"
      local server_capabilities = {}
      opts.servers = opts.servers or {} ---@type remote.lsp.config[]
      opts.capabilities = vim.tbl_deep_extend("force", handlers.get_client_capabilities(), opts.capabilities or {})

      vim.lsp.config("*", { capabilities = opts.capabilities })
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      ds.fs.walk("lsp", function(path, name, kind)
        if (kind == "file" or kind == "link") and name:match "%.lua$" then
          local fname = name:sub(1, -5)
          local mod = assert(loadfile(path))() ---@type remote.lsp.config
          if type(mod) == "function" then mod = mod() end
          if mod.disabled then return end
          if mod.setup then mod.setup(mod.config or {}) end
          if mod.defer_setup then return end
          opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, { [fname] = mod.config })
          server_capabilities =
            vim.tbl_deep_extend("force", server_capabilities, { [fname] = (mod.server_capabilities or {}) })
        end
      end)

      ds.tbl_each(opts.servers, function(config, server)
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = ds.augroup "remote.lsp.attach",
        callback = function(event)
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id)) ---@type vim.lsp.Client
          handlers.on_attach(client, event.buf, server_capabilities[client.name])
        end,
      })
    end),
  },
}
