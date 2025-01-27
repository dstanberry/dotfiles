return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        highlight_headers = true,
        show_help = true,
        answer_header = string.format(" %s %s ", ds.icons.kind.Copilot, "Copilot"),
        question_header = string.format(" %s %s ", ds.icons.misc.User, user),
        error_header = "> [!ERROR] Error",
        separator = "───",
        window = {
          layout = "float",
          relative = "cursor",
          width = 1,
          height = 0.4,
          row = 1,
          border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
        },
        selection = function(source)
          local select = require "CopilotChat.select"
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = function()
      local _toggle = function() require("CopilotChat").toggle() end
      local _clear = function() return require("CopilotChat").reset() end
      local _chat = function()
        local actions = require "CopilotChat.actions"
        local items = vim.tbl_deep_extend("keep", { prompt = "Copilot Quick Actions" }, actions.prompt_actions())
        require("CopilotChat.integrations.snacks").pick(items, {
          layout = {
            preset = "vertical",
            layout = { height = math.floor(math.min(vim.o.lines * 0.6 - 10, #items.actions) + 0.5) + 1 },
          },
        })
      end

      return {
        { "<leader>c", mode = { "n", "v" }, "", desc = "+copilot" },
        { "<leader>cc", mode = { "n", "v" }, _toggle, desc = "copilot: toggle chat" },
        { "<leader>ca", mode = { "n", "v" }, _chat, desc = "copilot: quick chat" },
        { "<leader>cx", mode = { "n", "v" }, _clear, desc = "copilot: clear history" },
      }
    end,
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function(args)
          require("ft").setup(
            args.buf,
            { wo = { cursorline = false, number = false, relativenumber = false, winhighlight = "Title:PMenuSBar" } }
          )
        end,
      })
    end,
  },
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
    "folke/flash.nvim",
    event = "LazyFile",
    keys = function()
      local _jump = function() require("flash").jump() end
      local _treesitter = function() require("flash").treesitter() end
      local _remote = function() require("flash").remote() end
      local _treesitter_search = function() require("flash").treesitter_search() end

      return {
        { "r", mode = "o", _remote, desc = "flash: do operation on <pattern>" },
        { "s", mode = { "n", "o", "x" }, _jump, desc = "flash: jump to <pattern>" },
        { "S", mode = { "n", "o", "x" }, _treesitter, desc = "flash: select treesitter node" },
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
