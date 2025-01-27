return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "LazyFile",
    cmd = "Copilot",
    opts = {
      filetypes = { ["*"] = true },
      panel = { enabled = false },
      suggestion = { enabled = false },
      server_opts_overrides = {
        settings = {
          advanced = { debug = { acceptselfSignedCertificate = true } },
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
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
    init = function()
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
  },
}
