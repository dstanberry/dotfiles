return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      rocks = { "tiktoken_core" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "LazyFile",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end, desc = "persistence: save session" },
      { "<leader>qS", function() require("persistence").stop() end, desc = "persistence: untrack session" },
      { "<leader>qr", function() require("persistence").load() end, desc = "persistence: restore session" },
    },
  },
  {
    "folke/trouble.nvim",
    event = "LazyFile",
    cmd = { "Trouble" },
    keys = function()
      local _definitions = function() vim.cmd { cmd = "Trouble", args = { "lsp_def", "toggle" } } end
      local _implementation = function() vim.cmd { cmd = "Trouble", args = { "lsp_impl", "toggle" } } end
      local _references = function() vim.cmd { cmd = "Trouble", args = { "lsp_ref", "toggle" } } end
      local _symbols = function() vim.cmd { cmd = "Trouble", args = { "symbols", "toggle" } } end
      local _type_definitions = function() vim.cmd { cmd = "Trouble", args = { "lsp_type_def", "toggle" } } end
      local _diagnostics = function() vim.cmd { cmd = "Trouble", args = { "lsp_diag", "toggle" } } end
      local _diagnostics_cascade = function() vim.cmd { cmd = "Trouble", args = { "lsp_diag_cascade", "toggle" } } end
      local _location_list = function() vim.cmd { cmd = "Trouble", args = { "loclist", "toggle" } } end
      local _quickfix_list = function() vim.cmd { cmd = "Trouble", args = { "qflist", "toggle" } } end
      local _next = function()
        if require("trouble").is_open() then
          require("trouble").next { skip_groups = true, jump = true }
        else
          pcall(vim.cmd.cnext)
        end
      end
      local _previous = function()
        if require("trouble").is_open() then
          require("trouble").prev { skip_groups = true, jump = true }
        else
          pcall(vim.cmd.cprevious)
        end
      end

      return {
        { "gD", _definitions, desc = "trouble: lsp definitions" },
        { "gI", _implementation, desc = "trouble: lsp implementations" },
        { "gR", _references, desc = "trouble: lsp references" },
        { "gS", _symbols, desc = "trouble: lsp document symbols" },
        { "gT", _type_definitions, desc = "trouble: lsp type definitions" },
        { "gWa", _diagnostics, desc = "trouble: workspace diagnostics" },
        { "gWf", _diagnostics_cascade, desc = "trouble: filtered diagnostics" },
        { "<localleader>ql", _location_list, desc = "trouble: location list" },
        { "<localleader>qq", _quickfix_list, desc = "trouble: quickfix list" },
        { "<c-up>", _previous, desc = "trouble: previous item" },
        { "<c-down>", _next, desc = "trouble: next item" },
      }
    end,
    opts = function()
      local preview_opts = {
        type = "float",
        relative = "editor",
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
        position = { 0.5, 0.5 },
        size = { width = 0.6, height = 0.5 },
        zindex = 200,
      }
      return {
        icons = {
          kinds = vim.tbl_extend(
            "keep",
            vim.tbl_map(function(kind) return ds.pad(kind, "right") end, ds.icons.kind),
            vim.tbl_map(function(kind) return ds.pad(kind, "right") end, ds.icons.type)
          ),
        },
        modes = {
          lsp_def = { mode = "lsp_definitions", preview = preview_opts },
          lsp_impl = { mode = "lsp_implementations", preview = preview_opts },
          lsp_ref = { mode = "lsp_references", preview = preview_opts },
          lsp_type_def = { mode = "lsp_type_definitions", preview = preview_opts },
          lsp_diag = {
            mode = "diagnostics",
            filter = {
              any = {
                buf = 0,
                {
                  severity = vim.diagnostic.severity.WARN,
                  function(item) return item.filename:find(ds.root.get(), 1, true) end,
                },
              },
            },
          },
          lsp_diag_cascade = {
            mode = "diagnostics",
            filter = function(items)
              local severity = vim.diagnostic.severity.HINT
              for _, item in ipairs(items) do
                severity = math.min(severity, item.severity)
              end
              return vim.tbl_filter(function(item) return item.severity == severity end, items)
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      -- HACK: temporarily monkey-patch `vim.lsp`` deprecation warnings until fixed upstream
      local ok, lsp = pcall(require, "trouble.sources.lsp")
      if ok and type(lsp) == "table" then
        local Promise = require "trouble.promise"
        lsp.request = function(method, params, ropts)
          ropts = ropts or {}
          local buf = vim.api.nvim_get_current_buf()
          local clients = {} ---@type vim.lsp.Client[]
          if ropts.client then
            clients = { ropts.client }
          else
            if vim.lsp.get_clients then
              clients = vim.lsp.get_clients { method = method, bufnr = buf }
            else
              clients = vim.lsp.get_clients { bufnr = buf }
              clients = vim.tbl_filter(function(client) ---@param client vim.lsp.Client
                return client:supports_method(method)
              end, clients)
            end
          end
          return Promise.all(vim.tbl_map(function(client)
            return Promise.new(function(resolve)
              local p = type(params) == "function" and params(client) or params --[[@as table]]
              client:request(
                method,
                p,
                function(err, result) resolve { client = client, result = result, err = err, params = p } end,
                buf
              )
            end)
          end, clients)):next(function(results)
            ---@param v trouble.lsp.Response<any,any>
            return vim.tbl_filter(function(v) return v.result end, results)
          end)
        end
      end
      require("trouble").setup(opts)
    end,
  },
}
