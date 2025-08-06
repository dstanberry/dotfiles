return {
  {
    "zbirenbaum/copilot.lua",
    build = ":Copilot auth",
    event = "LazyFile",
    cmd = "Copilot",
    init = function()
      ds.snippet.ai = function()
        local copilot = require "copilot.suggestion"
        if copilot.is_visible() then
          local chord = vim.api.nvim_replace_termcodes("<c-g>u", true, true, true)
          if vim.api.nvim_get_mode().mode == "i" then vim.api.nvim_feedkeys(chord, "n", false) end
          copilot.accept()
          return true
        end
        if ds.cmp.visible "menu" and ds.cmp.visible "ghost_text" then
          vim.schedule(function()
            ds.cmp.confirm()
            ds.cmp.show()
          end)
          return true
        end
      end
    end,
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
        { "<leader>cm", function() vim.cmd "CopilotChatModels" end, desc = "copilot: select model" },
        { "<leader>cx", mode = { "n", "v" }, _clear, desc = "copilot: clear history" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function(args)
          ds.ft.set_options(args.buf, { wo = { cursorline = false, number = false, relativenumber = false } })
        end,
      })
    end,
    opts = {
      agent = "copilot",
      model = "gpt-4.1",
      auto_follow_cursor = false,
      auto_insert_mode = false,
      insert_at_end = false,
      highlight_headers = true,
      show_folds = false,
      show_help = true,
      separator = "───",
      headers = {
        assistant = string.format(" %s %s ", ds.icons.kind.Copilot, "Copilot"),
        user = string.format(" %s %s ", ds.icons.misc.User, (vim.env.USER or "User"):gsub("^%l", string.upper)),
      },
      selection = function(source)
        local select = require "CopilotChat.select"
        return select.visual(source)
      end,
      window = vim.o.columns > 180 and { layout = "vertical", width = 82 } or { layout = "horizontal", height = 0.4 },
      sticky = { "#buffers" },
      prompts = {
        -- programming
        Explain = {
          sticky = { "#buffers" },
          prompt = [[Provide a high-level overview of what the code does, including its key functions or classes and
           their roles. Summarize the logic flow, highlight any notable or complex segments, and specify the expected
           input and output with examples.]],
        },
        Fix = {
          sticky = { "#buffers", "#diagnostics" },
          prompt = [[Analyze the code for issues and provide suggestions on how it can be resolved using clear and
          efficient solutions. The analysis should address syntax errors, logical errors, diagnostic errors,
          performance ineffificiences, security vulnerabilities, code style, adherence to modern best practices,
          and any other potential issues.]],
        },
        Names = {
          sticky = { "#buffers" },
          prompt = [[Analyze the declared variables, objects and types, and suggest more descriptive and meaningful
          names that improve code readability and maintainability. Follow modern best practices and recommendations
          for the language]],
        },
        Refactor = {
          sticky = { "#buffers" },
          prompt = [[Refactor the code to enhance readability, maintainability, and efficiency. Focus on organizing the
          structure, using clear and consistent naming, removing redundancies, simplifying logic, implementing robust
          error handling, and improving comments or documentation for clarity.]],
        },
        Tests = {
          sticky = { "#buffers" },
          prompt = [[Generate unit tests using modern best practices for writing maintainable and effective unit tests
          in this language, ensuring proper use of AAA (Arrange-Act-Assert), test isolation, and clear assertions]],
        },
        -- note taking
        Concise = "Rewrite the following text to make it more concise.",
        Grammar = "Improve the grammar and wording of the following text.",
        Spelling = "Correct any grammar and spelling errors in the following text.",
      },
    },
  },
}
