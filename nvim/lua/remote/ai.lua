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
        { "<leader>cm", function() vim.cmd "CopilotChatModels" end, desc = "copilot: select model" },
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
        Explain = {
          context = { "buffer" },
          prompt = [[Provide a high-level overview of what the code does, including its key functions or classes and
           their roles. Summarize the logic flow, highlight any notable or complex segments, and specify the expected
           input and output with examples.]],
        },
        Fix = {
          context = { "diagnostics", "buffers" },
          prompt = [[Analyze the code for issues and provide suggestions on how it can be resolved using clear and
          efficient solutions. The analysis should address syntax errors, logical errors, diagnostic errors,
          performance ineffificiences, security vulnerabilities, code style, adherence to modern best practices,
          and any other potential issues.]],
        },
        Names = {
          context = { "buffers" },
          prompt = [[Analyze the declared variables, objects and types, and suggest more descriptive and meaningful
          names that improve code readability and maintainability. Follow modern best practices and recommendations
          for the language]],
        },
        Refactor = {
          context = { "buffers" },
          prompt = [[Refactor the code to enhance readability, maintainability, and efficiency. Focus on organizing the
          structure, using clear and consistent naming, removing redundancies, simplifying logic, implementing robust
          error handling, and improving comments or documentation for clarity.]],
        },
        Tests = {
          context = { "buffers" },
          prompt = [[Generate unit tests using modern best practices for writing maintainable and effective unit tests
          in this language, ensuring proper use of AAA (Arrange-Act-Assert), test isolation, and clear assertions]],
        },
        -- note taking
        Concise = "Rewrite the following text to make it more concise.",
        Grammar = "Improve the grammar and wording of the following text.",
        Spelling = "Correct any grammar and spelling errors in the following text.",
      }

      return { ---@type CopilotChat.config
        agent = "copilot",
        model = "gpt-4o",
        auto_insert_mode = true,
        highlight_headers = true,
        show_folds = false,
        show_help = true,
        auto_follow_cursor = false,
        insert_at_end = true,
        answer_header = string.format(" %s %s ", ds.icons.kind.Copilot, "Copilot"),
        question_header = string.format(" %s %s ", ds.icons.misc.User, user),
        error_header = "> [!ERROR] Error",
        separator = "───",
        prompts = prompts,
        selection = function(source)
          local select = require "CopilotChat.select"
          return select.visual(source)
        end,
        contexts = {
          cwd = {
            description = "Includes files from the specified buffer relative to it's current working directory, in the chat context.",
            input = function(callback)
              vim.ui.select(
                vim.tbl_map(
                  function(buf)
                    return { bufnr = buf, name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p:.") }
                  end,
                  ds.buffer.filter { listed = true, no_terminal = true }
                ),
                {
                  prompt = "Select a buffer",
                  format_item = function(item) return item.name end,
                },
                function(choice) callback(choice and choice.bufnr) end
              )
            end,
            resolve = function(input, source)
              local files = {}
              local file = vim.api.nvim_buf_get_name(tonumber(input) or source.bufnr)
              local root = vim.fs.normalize(vim.fs.dirname(file))
              ds.fs.walk(root, function(path, _, type)
                if (type == "file" or type == "link") and vim.fs.dirname(path) == root then
                  table.insert(files, {
                    filename = path,
                    content = ds.fs.read(path),
                    filetype = vim.filetype.match { filename = path },
                  })
                end
              end)
              return files
            end,
          },
          diagnostics = {
            description = "All workspace diagnostics",
            resolve = function(_, source)
              local diagnostics = vim.diagnostic.get(source.bufnr, { severity = vim.diagnostic.severity.INFO })
              local lines = {}
              local severities = {
                [vim.diagnostic.severity.ERROR] = "Error",
                [vim.diagnostic.severity.WARN] = "Warn",
                [vim.diagnostic.severity.INFO] = "Info",
                [vim.diagnostic.severity.HINT] = "Hint",
              }
              require("CopilotChat.utils").schedule_main()
              for _, diag in ipairs(diagnostics) do
                local file = vim.fs.normalize(vim.api.nvim_buf_get_name(diag.bufnr))
                table.insert(
                  lines,
                  string.format(
                    "%s:%d [%s]: %s",
                    file,
                    (diag.lnum or 0) + 1,
                    severities[diag.severity] or "",
                    diag.message or ""
                  )
                )
              end
              return {
                {
                  content = table.concat(lines, "\n"),
                  filename = "workspace_diagnostics",
                  filetype = "text",
                },
              }
            end,
          },
        },
        window = vim.o.columns > 180 and { layout = "vertical", width = 82 } or {
          layout = "float",
          relative = "cursor",
          border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
          width = 1,
          height = 0.5,
          row = 1,
        },
      }
    end,
  },
}
