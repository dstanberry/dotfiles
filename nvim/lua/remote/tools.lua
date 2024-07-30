return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "gennaro-tedesco/nvim-jqx", ft = "json" },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "ff",
        function() require("conform").format { async = true, lsp_format = "fallback" } end,
        desc = "conform: format document",
      },
    },
    init = function()
      vim.g.conform_slow_formatters = {}
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.conform_formatting_disabled = true
        else
          vim.g.conform_formatting_disabled = true
        end
        print "Disabled auto-format on save."
      end, {
        desc = "conform: disable auto-format on save for this buffer",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.conform_formatting_disabled = false
        vim.g.conform_formatting_disabled = false
        print "Enabled auto-format on save."
      end, {
        desc = "conform: enable auto-format on save for this buffer",
      })
    end,
    opts = function()
      local prettier_conf = ds.root.detectors.pattern(0, {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yaml",
        ".prettierrc.js",
        ".prettierrc.mjs",
        ".prettierrc.cjs",
        ".prettierrc.toml",
      })[1] or ""

      local function first(bufnr, ...)
        local conform = require "conform"
        for i = 1, select("#", ...) do
          local formatter = select(i, ...)
          if conform.get_formatter_info(formatter, bufnr).available then return formatter end
        end
        return select(1, ...)
      end

      return {
        formatters_by_ft = {
          bash = { "shfmt" },
          cs = { "csharpier" },
          go = { "goimports", "gofumpt" },
          html = { "prettierd", "prettier", stop_after_first = true },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          jsonc = { "prettierd", "prettier", stop_after_first = true },
          lua = { "stylua" },
          markdown = function(bufnr)
            return { first(bufnr, "prettierd", "prettier"), "markdownlint-cli2", "markdown-toc", "cbfmt" }
          end,
          ["markdown.mdx"] = function(bufnr)
            return { first(bufnr, "prettierd", "prettier"), "markdownlint-cli2", "markdown-toc", "cbfmt" }
          end,
          psql = { "sqlfluff" },
          -- python = { "injected", "black" },
          python = { "black" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          sql = { "sqlfluff" },
          terraform = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          tf = { "terraform_fmt" },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "yamlfmt" },
          zsh = { "shfmt" },
        },
        formatters = {
          csharpier = {
            command = "dotnet-csharpier",
            args = { "--write-stdout" },
          },
          ["markdown-toc"] = {
            condition = function(_, ctx)
              for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                if line:find "<!%-%- toc %-%->" then return true end
              end
            end,
          },
          ["markdownlint-cli2"] = {
            condition = function(_, ctx)
              local diag = vim.tbl_filter(
                function(d) return d.source == "markdownlint" end,
                vim.diagnostic.get(ctx.buf)
              )
              return #diag > 0
            end,
          },
          prettierd = {
            env = vim.uv.fs_realpath(prettier_conf) and { PRETTIERD_DEFAULT_CONFIG = prettier_conf } or nil,
          },
          shfmt = {
            prepend_args = { "-i", "2", "-ci", "-sr", "-s", "-bn" },
          },
          sqlfluff = {
            args = { "format", "--dialect=postgres", "-" },
          },
        },
        format_on_save = function(buf)
          if vim.g.conform_formatting_disabled or vim.b[buf].conform_formatting_disabled then return end
          if vim.g.conform_slow_formatters[vim.bo[buf].filetype] then return end

          local on_format = function(err)
            if err and err:match "timeout$" then vim.g.conform_slow_formatters[vim.bo[buf].filetype] = true end
          end

          vim.api.nvim_exec_autocmds("User", { pattern = "FormatPre" })

          return { timeout_ms = 2500, lsp_format = "fallback" }, on_format
        end,
        format_after_save = function(buf)
          if not vim.g.conform_slow_formatters[vim.bo[buf].filetype] then return end
          return { lsp_format = "fallback" }
        end,
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    keys = function()
      ---@diagnostic disable-next-line: missing-fields
      local _debug = function() require("neotest").run.run { vim.fn.expand "%", strategy = "dap" } end
      local _file = function() require("neotest").run.run(vim.fn.expand "%") end
      local _dir = function() require("neotest").run.run(vim.uv.cwd()) end
      local _nearest = function() require("neotest").run.run() end
      local _last = function() require("neotest").run.run_last() end
      local _summary = function() require("neotest").summary.toggle() end
      local _out = function() require("neotest").output.open { enter = true, auto_close = true } end
      local _panel = function() require("neotest").output_panel.toggle() end
      local _stop = function() require("neotest").run.stop() end
      local _watch = function() require("neotest").watch.toggle(vim.fn.expand "%") end

      return {
        { "<leader>t", "", desc = "+test" },
        { "<leader>td", _debug, desc = "test: debug test" },
        { "<leader>tr", _file, desc = "test: run file" },
        { "<leader>tR", _dir, desc = "test: run all test files" },
        { "<leader>tn", _nearest, desc = "test: run nearest" },
        { "<leader>tl", _last, desc = "test: run last" },
        { "<leader>ts", _summary, desc = "test: toggle summary" },
        { "<leader>to", _out, desc = "test: show output" },
        { "<leader>tO", _panel, desc = "test: toggle output panel" },
        { "<leader>tt", _stop, desc = "test: stop" },
        { "<leader>tw", _watch, desc = "test: toggle watch" },
      }
    end,
    opts = function()
      local adapters = {}
      adapters["neotest-python"] = { runner = "pytest" }
      local py_venv = vim.fs.find({ ".venv", "venv" }, { path = vim.uv.cwd(), upward = true })[1]
      if py_venv then
        local root = ds.has "win32" and py_venv .. "/Scripts/pythonw.exe" or py_venv .. "bin/python"
        adapters["neotest-python"]["python"] = root
      end
      return {
        adapters = adapters,
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            if ds.plugin.is_installed "trouble.nvim" then
              require("trouble").open { mode = "quickfix", focus = false }
            else
              vim.cmd "copen"
            end
          end,
        },
      }
    end,
    config = function(_, opts)
      local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_html_extmarks"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, NAMESPACE_ID)
      if ds.plugin.is_installed "trouble.nvim" then
        opts.consumers = opts.consumers or {}
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then return end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))
            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then failed = failed + 1 end
            end
            vim.schedule(function()
              local trouble = require "trouble"
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then trouble.close() end
              end
            end)
            return {}
          end
        end
      end
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then config = require(config) end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                ds.error(name .. "does not support setup", { title = "Neotest" })
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end
      require("neotest").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
      linters = {
        sqlfluff = {
          args = { "lint", "--format=json", "--dialect=postgres", "--exclude-rules=L044,LT02,LT12" },
        },
      },
    },
    config = function(_, opts)
      local M = {}
      local lint = require "lint"

      ds.foreach(opts.linters, function(linter, name)
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          elseif type(linter.args) == "table" then
            lint.linters[name].args = linter.args
          end
        else
          lint.linters[name] = linter
        end
      end)
      lint.linters_by_ft = opts.linters_by_ft

      M.lint = function()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        if #names == 0 then vim.list_extend(names, lint.linters_by_ft["_"] or {}) end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fs.dirname(ctx.filename)
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then ds.warn("Linter not found: " .. name) end
          ---@diagnostic disable-next-line: undefined-field
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        if #names > 0 then lint.try_lint(names) end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = ds.augroup "lint",
        callback = ds.debounce(M.lint, 100),
      })
    end,
  },
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    keys = {
      {
        "<leader>sc",
        function()
          local _, range = ds.buffer.get_visual_selection()
          local left = range[1][1] or 1
          local right = range[2][1] or 1
          vim.cmd { cmd = "Silicon", range = { left + 1, right + 1 } }
        end,
        mode = "v",
        desc = "silicon: screenshot selection",
      },
    },
    opts = {
      disable_defaults = false,
      debug = false,
      command = "silicon",
      font = "CartographCF Nerd Font=30",
      background = ds.color.blend(vim.g.ds_colors.purple1, vim.g.ds_colors.bg2, 0.44),
      theme = "kdark",
      line_offset = function(args) return args.line1 end,
      window_title = function() return vim.fs.basename(vim.api.nvim_buf_get_name(0)) end,
    },
    config = function(_, opts) require("silicon").setup(opts) end,
  },
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    opts = {
      package_manager = "npm",
      colors = {},
    },
    init = function()
      ds.hl.new("PackageInfoOutdatedVersion", { link = "DiagnosticVirtualTextWarn" })
      ds.hl.new("PackageInfoUpToDateVersion", { link = "DiagnosticVirtualTextInfo" })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    keys = function()
      local _resize_left = function() require("smart-splits").resize_left(1) end
      local _resize_down = function() require("smart-splits").resize_down(1) end
      local _resize_up = function() require("smart-splits").resize_up(1) end
      local _resize_right = function() require("smart-splits").resize_right(1) end
      local _move_left = function() require("smart-splits").move_cursor_left() end
      local _move_down = function() require("smart-splits").move_cursor_down() end
      local _move_up = function() require("smart-splits").move_cursor_up() end
      local _move_right = function() require("smart-splits").move_cursor_right() end
      local _swap_left = function() require("smart-splits").swap_buf_left() end
      local _swap_down = function() require("smart-splits").swap_buf_down() end
      local _swap_up = function() require("smart-splits").swap_buf_up() end
      local _swap_right = function() require("smart-splits").swap_buf_right() end
      return {
        { "<a-h>", _resize_left, desc = "smart-splits: resize left" },
        { "<a-j>", _resize_down, desc = "smart-splits: resize down" },
        { "<a-k>", _resize_up, desc = "smart-splits: resize up" },
        { "<a-l>", _resize_right, desc = "smart-splits: resize right" },
        { "<c-h>", _move_left, desc = "smart-splits: move to left window" },
        { "<c-j>", _move_down, desc = "smart-splits: move to lower window" },
        { "<c-k>", _move_up, desc = "smart-splits: move to upper window" },
        { "<c-l>", _move_right, desc = "smart-splits: move to right window" },
        { "<localleader><localleader>h", _swap_left, desc = "smart-splits: swap with left window" },
        { "<localleader><localleader>j", _swap_down, desc = "smart-splits: swap with lower window" },
        { "<localleader><localleader>k", _swap_up, desc = "smart-splits: swap with upper window" },
        { "<localleader><localleader>l", _swap_right, desc = "smart-splits: swap with right window" },
      }
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "tpope/vim-dadbod",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      {
        "<localleader>de",
        function() vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath "data", "db", "connections.json")) end,
        desc = "dadbod: edit database connections",
      },
      { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
    },
    init = function()
      vim.g.db_ui_save_location = vim.fs.joinpath(vim.fn.stdpath "data", "db")
      vim.g.db_ui_tmp_query_location = vim.fs.joinpath(vim.fn.stdpath "data", "db", "tmp")
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_execute_on_save = false

      vim.api.nvim_create_autocmd("FileType", {
        group = ds.augroup "dadbod",
        pattern = { "dbout", "dbui" },
        callback = function()
          vim.opt_local.winhighlight = "Normal:NormalSB"
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
    config = function()
      ds.plugin.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.g.ds_cmp_group,
          pattern = "sql",
          callback = function()
            local plugin = require("lazy.core.config").spec.plugins["nvim-cmp"]
            local sources = require("lazy.core.plugin").values(plugin, "opts", false).sources or {}
            table.insert(sources, { name = "vim-dadbod-completion" })
            require("cmp").setup.buffer { sources = sources }
          end,
        })
      end)
    end,
  },
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    dependencies = { "MattiasMTS/cmp-dbee" },
    cmd = { "Dbee" },
    keys = {
      { "<localleader>db", "<cmd>Dbee toggle<cr>", desc = "dbee: toggle interface" },
    },
    build = function() require("dbee").install "curl" end,
    config = function()
      require("dbee").setup {
        sources = {
          require("dbee.sources").FileSource:new(vim.fs.joinpath(vim.fn.stdpath "data", "db", "connections.json")),
        },
      }
      ds.plugin.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.g.ds_cmp_group,
          pattern = "sql",
          callback = function()
            local plugin = require("lazy.core.config").spec.plugins["nvim-cmp"]
            local sources = require("lazy.core.plugin").values(plugin, "opts", false).sources or {}
            table.insert(sources, { name = "cmp-dbee" })
            require("cmp").setup.buffer { sources = sources }
          end,
        })
      end)
    end,
  },
}
