return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log" },
  {
    "monaqa/dial.nvim",
    keys = function()
      local dial = function(increment)
        local mode = vim.fn.mode(true)
        -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
        local is_visual = mode == "v" or mode == "V" or mode == "\22"
        local func = (increment and "inc_" or "dec_") .. (is_visual and "visual" or "normal")
        local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
        return require("dial.map")[func](group)
      end
      return {
        { "<c-a>", function() return dial(true) end, expr = true, desc = "dial: increment", mode = { "n", "v" } },
        { "<c-x>", function() return dial(false) end, expr = true, desc = "dial: decrement", mode = { "n", "v" } },
      }
    end,
    opts = function()
      local augend = require "dial.augend"
      -- stylua: ignore
      local ordinal_numbers = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" }
      -- stylua: ignore
      local months = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
      local weekdays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
      return {
        dials_by_ft = {
          javascript = "typescript",
          typescript = "typescript",
          typescriptreact = "typescript",
          javascriptreact = "typescript",
          markdown = "markdown",
        },
        groups = {
          default = {
            augend.constant.alias.bool,
            augend.integer.alias.decimal,
            augend.integer.alias.decimal_int,
            augend.integer.alias.hex,
            augend.semver.alias.semver,
            augend.date.alias["%Y/%m/%d"],
            augend.constant.new { elements = { "True", "False" }, word = true, cyclic = true },
            augend.constant.new { elements = { "and", "or" }, word = true, cyclic = true },
            augend.constant.new { elements = { "&&", "||" }, word = false, cyclic = true },
            augend.constant.new { elements = ordinal_numbers, word = true, cyclic = true },
            augend.constant.new { elements = weekdays, word = true, cyclic = true },
            augend.constant.new { elements = months, word = true, cyclic = true },
          },
          markdown = {
            augend.misc.alias.markdown_header,
            augend.constant.new { elements = { "[ ]", "[x]" }, word = false, cyclic = true },
          },
          typescript = {
            augend.constant.new { elements = { "let", "const" }, word = true, cyclic = true },
          },
        },
      }
    end,
    config = function(_, opts)
      for name, group in pairs(opts.groups) do
        if name ~= "default" then vim.list_extend(group, opts.groups.default) end
      end
      require("dial.config").augends:register_group(opts.groups)
      vim.g.dials_by_ft = opts.dials_by_ft
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
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
        group = ds.augroup "remote.conform",
        pattern = "VeryLazy",
        callback = function()
          local keys = {
            { key = "f<backspace>", opts = ds.format.toggle(true) },
            { key = "f<delete>", opts = ds.format.toggle() },
          }
          ds.format.register {
            name = "conform.nvim",
            modname = "conform",
            primary = true,
            priority = 100,
            format = function(buf) require("conform").format { bufnr = buf } end,
            sources = function(buf)
              local ret = require("conform").list_formatters(buf)
              return vim.tbl_map(function(v) return v.name end, ret)
            end,
          }
          ds.tbl_each(keys, function(entry)
            local opts = vim.tbl_extend("force", {}, entry.opts)
            if ds.plugin.is_installed "snacks.nvim" then
              Snacks.toggle({
                notify = false,
                wk_desc = { enabled = opts.enabled, disabled = opts.disabled },
                name = opts.desc,
                get = opts.get,
                set = opts.set,
              }):map(entry.key)
            else
              if opts.map and type(opts.map) == "function" then opts.map(entry.key) end
            end
          end)
        end,
      })
    end,
    opts = function()
      local config_resolvers = {
        prettier = function(ctx)
          local c = vim.fn.system { "prettier", "--find-config-path", ctx.filename }
          if vim.v.shell_error == 0 and c and c ~= "" then return (c:gsub("%s+$", "")) end
        end,
        stylua = function(ctx)
          local dir = ds.root.detectors.pattern(ctx.buf, { "stylua.toml" })[1]
          if dir then return vim.fs.joinpath(dir, "stylua.toml") end
        end,
        ["markdownlint-cli2"] = function(ctx)
          local conf
          -- stylua: ignore
          local patterns = {
            ".markdownlint-cli2.jsonc", ".markdownlint-cli2.yaml",
            ".markdownlint-cli2.cjs", ".markdownlint-cli2.mjs",
            ".markdownlint.jsonc", ".markdownlint.json",
            ".markdownlint.yaml", ".markdownlint.yml",
            ".markdownlint.cjs", ".markdownlint.mjs",
            "package.json",
          }
          ds.tbl_each(patterns, function(v)
            if not conf then
              local dir = ds.root.detectors.pattern(ctx.buf, { v })[1]
              if dir then conf = vim.fs.joinpath(dir, v) end
            end
          end)
          return conf
        end,
      }
      local get_config = ds.memoize(function(tool, ctx)
        local r = config_resolvers[tool]
        return (r and r(ctx)) or false
      end)

      return {
        default_format_opts = { async = false, quiet = false, lsp_format = "fallback", timeout_ms = 3000 },
        formatters_by_ft = {
          bash = { "shfmt" },
          css = { "prettier" },
          go = { "goimports", "gofumpt" },
          graphql = { "prettier" },
          groovy = { "npm-groovy-lint" },
          html = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          jenkinsfile = { "npm-groovy-lint" },
          json = { "prettier" },
          jsonc = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
          ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
          psql = { "sqlfluff" },
          -- python = { "injected", "black" },
          python = { "black" },
          rust = { "rustfmt" },
          scss = { "prettier" },
          sh = { "shfmt" },
          sql = { "sqlfluff" },
          terraform = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          tf = { "terraform_fmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "yamlfmt" },
          zsh = { "beautysh" },
        },
        formatters = {
          beautysh = { args = { "-i", "2", "-" } },
          ["markdown-toc"] = {
            condition = function(_, ctx)
              for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                if line:find "<!%-%- toc %-%->" then return true end
              end
              return false
            end,
          },
          ["markdownlint-cli2"] = {
            prepend_args = function(_, ctx)
              local config = get_config("markdownlint-cli2", ctx)
              local fallback = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "shared", "formatters", "def.markdownlint.json")
              return { "--config", config or fallback }
            end,
          },
          prettier = {
            prepend_args = function(_, ctx)
              local config = get_config("prettier", ctx)
              config = vim.uv.fs_realpath(config or "")
              local fallback = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "shared", "formatters", "prettierrc.json")
              return { "--config", config or fallback }
            end,
          },
          shfmt = {
            condition = function(_, ctx) return not vim.fs.basename(vim.api.nvim_buf_get_name(ctx.buf)):match "^%.env" end,
            prepend_args = { "-i", "2", "-ci", "-sr", "-s", "-bn" },
          },
          sqlfluff = { args = { "format", "--dialect=postgres", "-" } },
          stylua = {
            args = function(_, ctx)
              local config = get_config("stylua", ctx)
              local fallback = vim.fs.joinpath(vim.fn.stdpath "config", "stylua.toml")
              return { "--config-path", config or fallback, "--stdin-filepath", "$FILENAME", "-" }
            end,
          },
        },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "LazyFile",
    keys = function()
      local _jump = function() require("flash").jump() end
      local _remote = function() require("flash").remote() end
      local _treesitter = function() require("flash").treesitter() end
      local _treesitter_search = function() require("flash").treesitter_search() end

      return {
        { "r", mode = "o", _remote, desc = "flash: do operation on <pattern>" },
        { "R", mode = { "o", "x" }, _treesitter_search, desc = "flash: do (treesitter) operation on <pattern>" },
        { "s", mode = { "n", "o", "x" }, _jump, desc = "flash: jump to <pattern>" },
        { "S", mode = { "n", "o", "x" }, _treesitter, desc = "flash: select treesitter node" },
      }
    end,
    opts = {
      modes = {
        char = { keys = { "f", "F", "t", "T", [";"] = "<c-right>", [","] = "<c-left>" } },
        search = { enabled = false },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = ds.augroup "remote.grug-far",
        pattern = "grug-far",
        callback = vim.schedule_wrap(function()
          vim.opt_local.cursorline = false
          vim.opt_local.wrap = false
        end),
      })
    end,
    keys = function()
      local _finder = function()
        local grug = require "grug-far"
        local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
        grug.open { transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } }
      end

      return {
        { "<leader>s/", mode = { "n", "v" }, _finder, desc = "gruf-far: search/replace in files" },
      }
    end,
    opts = {
      headerMaxWidth = 80,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        dockerfile = { "hadolint" },
        markdown = { "markdownlint-cli2" },
        sh = { "dotenv_linter", "shellcheck" },
        sql = { "sqlfluff" },
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
      linters = {
        dotenv_linter = {
          condition = function(ctx) return vim.fs.basename(ctx.filename):match "^%.env" end,
        },
        shellcheck = {
          condition = function(ctx)
            return vim.fs.basename(ctx.filename):match "^%.bash" or vim.fs.basename(ctx.filename):match "^%.sh"
          end,
        },
        sqlfluff = {
          args = { "lint", "--format=json", "--dialect=postgres", "--exclude-rules=L044,LT02,LT12" },
        },
      },
    },
    config = function(_, opts)
      local M = {}
      local lint = require "lint"

      ds.tbl_each(opts.linters, function(linter, name)
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
        group = ds.augroup "remote.nvim-lint",
        callback = ds.debounce(M.lint, 100),
      })
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
  },
}
