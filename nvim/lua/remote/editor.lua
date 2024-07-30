return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4",
        auto_insert_mode = true,
        show_help = true,
        question_header = string.format("%s %s ", ds.icons.misc.User, user),
        answer_header = string.format("%s %s ", ds.icons.kind.Copilot, "Copilot"),
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require "CopilotChat.select"
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = function()
      local keys = {
        { "<leader>c", mode = { "n", "v" }, "", desc = "+copilot" },
        {
          "<leader>cc",
          mode = { "n", "v" },
          function() return require("CopilotChat").toggle() end,
          desc = "copilot: toggle chat",
        },
        {
          "<leader>ca",
          mode = { "n", "v" },
          function()
            local input = vim.fn.input "Ask Copilot: "
            if input ~= "" then require("CopilotChat").ask(input) end
          end,
          desc = "copilot: quick chat",
        },
        {
          "<leader>cx",
          mode = { "n", "v" },
          function() return require("CopilotChat").reset() end,
          desc = "copilot: clear history",
        },
      }
      return keys
    end,
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
      ds.plugin.on_load("telescope.nvim", function()
        vim.keymap.set({ "n", "v" }, "<leader>cd", function()
          local actions = require "CopilotChat.actions"
          local help = actions.help_actions()
          if not help then
            print "no diagnostics found on the current line"
            return
          end
          require("CopilotChat.integrations.telescope").pick(help)
        end, { desc = "copilot: show diagnostics help" })
        vim.keymap.set({ "n", "v" }, "<leader>cp", function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end, { desc = "copilot: show available actions" })
      end)
    end,
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<c-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "dial: increment" },
      { "<c-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "dial: decrement" },
    },
    config = function()
      local augend = require "dial.augend"
      local config = require "dial.config"

      local ordinal_numbers = augend.constant.new {
        elements = {
          "first",
          "second",
          "third",
          "fourth",
          "fifth",
          "sixth",
          "seventh",
          "eighth",
          "ninth",
          "tenth",
        },
        word = false,
        cyclic = true,
      }

      local weekdays = augend.constant.new {
        elements = {
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday",
        },
        word = true,
        cyclic = true,
      }

      local months = augend.constant.new {
        elements = {
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        },
        word = true,
        cyclic = true,
      }

      config.augends:register_group {
        default = {
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new {
            elements = {
              "True",
              "False",
            },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          ordinal_numbers,
          weekdays,
          months,
        },
        markdown = {
          augend.misc.alias.markdown_header,
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.new {
            elements = {
              "True",
              "False",
            },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          ordinal_numbers,
          weekdays,
          months,
        },
      }
    end,
  },
  {
    "folke/flash.nvim",
    event = "LazyFile",
    keys = function()
      local _jump = function() require("flash").jump() end
      local _treesitter = function() require("flash").treesitter() end
      local _remote = function() require("flash").remote() end
      local _treesitter_search = function() require("flash").treesitter_search() end
      return {
        { "s", mode = { "n", "o", "x" }, _jump, desc = "flash: jump to <pattern>" },
        { "S", mode = { "n", "o", "x" }, _treesitter, desc = "flash: select treesitter node" },
        { "r", mode = "o", _remote, desc = "flash: do operation on <pattern>" },
        { "R", mode = { "n", "o", "x" }, _treesitter_search, desc = "flash: do (treesitter) operation on <pattern>" },
      }
    end,
    opts = {
      modes = {
        char = { keys = { "f", "F", "t", "T", [";"] = "<c-right>", [","] = "<c-left>" } },
        search = { enabled = false },
      },
    },
  },
  -- Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = function()
      return {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      }
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "LazyFile",
  },
}
