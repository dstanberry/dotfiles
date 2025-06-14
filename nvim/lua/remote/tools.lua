return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "gennaro-tedesco/nvim-jqx", ft = "json" },
  {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    cmd = "ConformInfo",
    keys = function()
      local _format = function() ds.format.format { force = true } end
      local _formatInjected = function() require("conform").format { formatters = { "injected" }, timeout_ms = 3000 } end
      return {
        { "ff", mode = { "n", "v" }, _format, desc = "conform: format document" },
        { "fj", mode = { "n", "v" }, _formatInjected, desc = "conform: format injected language(s)" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          ds.format.register {
            name = "conform.nvim",
            priority = 100,
            primary = true,
            format = function(buf) require("conform").format { bufnr = buf } end,
            sources = function(buf)
              local ret = require("conform").list_formatters(buf)
              ---@param v conform.FormatterInfo
              return vim.tbl_map(function(v) return v.name end, ret)
            end,
          }
          ds.format.toggle():map "f<delete>"
          ds.format.toggle(true):map "f<backspace>"
        end,
      })
    end,
    opts = function()
      local function first(bufnr, ...)
        local conform = require "conform"
        for i = 1, select("#", ...) do
          local formatter = select(i, ...)
          if conform.get_formatter_info(formatter, bufnr).available then return formatter end
        end
        return select(1, ...)
      end
      return {
        default_format_opts = { async = false, quiet = false, lsp_format = "fallback", timeout_ms = 3000 },
        formatters_by_ft = {
          bash = { "shfmt" },
          go = { "goimports", "gofumpt" },
          groovy = { "npm-groovy-lint" },
          html = { "prettierd", "prettier", stop_after_first = true },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          jenkinsfile = { "npm-groovy-lint" },
          json = { "prettierd", "prettier", stop_after_first = true },
          jsonc = { "prettierd", "prettier", stop_after_first = true },
          lua = { "stylua" },
          markdown = function(bufnr)
            return { first(bufnr, "prettierd", "prettier"), "markdownlint-cli2", "markdown-toc" }
          end,
          ["markdown.mdx"] = function(bufnr)
            return { first(bufnr, "prettierd", "prettier"), "markdownlint-cli2", "markdown-toc" }
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
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "yamlfmt" },
          zsh = { "beautysh" },
        },
        formatters = {
          beautysh = {
            args = { "-i", "2", "-" },
          },
          ["markdown-toc"] = {
            condition = function(_, ctx)
              for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                if line:find "<!%-%- toc %-%->" then return true end
              end
            end,
          },
          prettierd = {
            env = function(_, ctx)
              local conf = ds.root.detectors.pattern(ctx.buf, {
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.yaml",
                ".prettierrc.js",
                ".prettierrc.mjs",
                ".prettierrc.cjs",
                ".prettierrc.toml",
              })[1] or ""
              return conf == "" and nil or { PRETTIERD_DEFAULT_CONFIG = conf }
            end,
          },
          shfmt = {
            prepend_args = { "-i", "2", "-ci", "-sr", "-s", "-bn" },
          },
          sqlfluff = {
            args = { "format", "--dialect=postgres", "-" },
          },
          stylua = {
            args = function(_, ctx)
              local root = ds.root.detectors.pattern(ctx.buf, { "stylua.toml" })[1] or ""
              local path = root == "" and vim.fs.joinpath(vim.fn.stdpath "config", "stylua.toml")
                or vim.fs.joinpath(root, "stylua.toml")
              return { "--config-path", path, "--stdin-filepath", "$FILENAME", "-" }
            end,
          },
        },
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      require("lazy").load { plugins = { "markdown-preview.nvim" } }
      vim.fn["mkdp#util#install"]()
    end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "preview: show in browser" },
    },
    config = function() vim.cmd [[do FileType]] end,
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
        local bin = ds.has "win32" and { "Scripts", "python.exe" } or { "bin", "python" }
        adapters["neotest-python"]["python"] = vim.fs.joinpath(py_venv, unpack(bin))
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
      local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_neotest_virtual_text"
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
        dockerfile = { "hadolint" },
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
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    opts = {
      package_manager = "npm",
      colors = {},
    },
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
    opts = {
      log_level = "fatal",
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = true,
    dependencies = {
      "tpope/vim-dadbod",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = function()
      local _edit = function() vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath "data", "db", "connections.json")) end

      return {
        { "<localleader>de", _edit, desc = "dadbod: edit database connections" },
        { "<localleader>db", "<cmd>DBUIToggle<cr>", desc = "dadbod: toggle interface" },
      }
    end,
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
  },
}
