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
    cmd = "CopilotChat",
    keys = function()
      local _chat = function() require("CopilotChat").select_prompt() end
      local _clear = function() return require("CopilotChat").reset() end
      local _toggle = function() require("CopilotChat").toggle() end

      return {
        { "<leader>c", mode = { "n", "v" }, "", desc = "+copilot" },
        { "<leader>ca", mode = { "n", "v" }, _chat, desc = "copilot: quick chat" },
        { "<leader>cc", mode = { "n", "v" }, _toggle, desc = "copilot: toggle chat" },
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

      local prompts = {
        -- programming
        Lint = "Please explain the linting errors and provide suggestions to fix them.",
        Names = "Please provide better names for the following variables and functions.",
        Refactor = "Please refactor the following code to improve its performance and readability.",
        Security = "Please analyze this code for potential security vulnerabilities and suggest fixes.",
        Tests = "Please explain how the selected code works, then generate unit tests for it.",
        -- note taking
        Concise = "Please rewrite the following text to make it more concise.",
        Grammar = "Please improve the grammar and wording of the following text.",
        Spelling = "Please correct any grammar and spelling errors in the following text.",
        Summarize = "Please summarize the following text.",
      }

      return {
        auto_insert_mode = true,
        highlight_headers = true,
        show_folds = false,
        show_help = true,
        model = "gpt-4o",
        answer_header = string.format(" %s %s ", ds.icons.kind.Copilot, "Copilot"),
        question_header = string.format(" %s %s ", ds.icons.misc.User, user),
        error_header = "> [!ERROR] Error",
        separator = "───",
        prompts = prompts,
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
