return {
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
  },
}
