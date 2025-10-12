return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "gennaro-tedesco/nvim-jqx", ft = "json" },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    opts = {
      default = {
        dir_path = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local root = ds.root.detectors.lsp(bufnr)[1] or vim.uv.cwd()
          return vim.fs.joinpath(root, "assets")
        end,
      },
      codecompanion = {
        prompt_for_file_name = false,
        template = "[Image]($FILE_PATH)",
        use_absolute_path = true,
      },
    },
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
    dependencies = { "nvim-neotest/nvim-nio", "nvim-neotest/neotest-python" },
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
    "mrjones2014/smart-splits.nvim",
    enabled = not ds.has "win32",
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
    dependencies = { "tpope/vim-dadbod" },
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
        group = ds.augroup "remote.dadbod",
        pattern = { "dbout", "dbui" },
        callback = vim.schedule_wrap(function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end),
      })
    end,
  },
}
