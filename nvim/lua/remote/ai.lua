return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
    keys = {
      { "<leader>c", mode = { "n", "x" }, "", desc = "+copilot" },
      { "<leader>ca", mode = { "n", "x" }, ":CodeCompanionActions<cr>", desc = "copilot: select action" },
      { "<leader>cc", "<cmd>CodeCompanionChat toggle<cr>", desc = "copilot: toggle chat" },
    },
    init = function()
      local spinners = ds.icons.spinners.Default
      local interval = 250
      local timer

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        callback = function(ctx)
          timer = assert(vim.uv.new_timer())
          timer:start(
            0,
            interval,
            vim.schedule_wrap(function()
              local spinner = spinners[math.floor(vim.uv.now() / interval) % #spinners + 1]
              ds.info(
                spinner .. " Processing...",
                { title = "Copilot", icon = ds.icons.kind.Copilot, timeout = false, id = ctx.data.id }
              )
            end)
          )
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        callback = function(ctx)
          timer:stop()
          timer:close()
          ds.info(
            ds.icons.misc.Check .. "Request finished",
            { title = "Copilot", icon = ds.icons.kind.Copilot, timeout = 2000, id = ctx.data.id }
          )
        end,
      })
    end,
    opts = {
      display = {
        chat = {
          auto_scroll = true,
          intro_message = "",
          window = vim.tbl_deep_extend(
            "force",
            vim.o.columns > 180 and { layout = "vertical", width = 82 } or { layout = "horizontal", height = 0.4 },
            {
              opts = { number = false, relativenumber = false, statuscolumn = " " },
            }
          ),
        },
      },
      extensions = {
        spinner = {},
        history = {
          opts = {
            keymap = "gh",
            auto_save = false,
            save_chat_keymap = "gs",
          },
        },
      },
      strategies = {
        chat = {
          adapter = { name = "copilot", model = vim.g.ds_env.copilot_model or "gpt-5" },
          keymaps = {
            close = { modes = { n = "q" }, opts = { nowait = true } },
            send = { modes = { n = "<cr>", i = "<c-s>" } },
            stop = { modes = { n = "<c-c>" } },
            next_header = { modes = { n = "]]" } },
            previous_header = { modes = { n = "[[" } },
          },
          roles = {
            llm = function(adapter)
              return string.format(
                "%s %s (%s - %s)",
                ds.icons.kind.Copilot,
                "Code Assistant",
                adapter.formatted_name,
                adapter.model.name
              )
            end,
            user = string.format("%s %s", ds.icons.misc.User, (vim.env.USER or "User"):gsub("^%l", string.upper)),
          },
        },
        cmd = {
          adapter = { name = "copilot", model = vim.g.ds_env.copilot_model or "gpt-5" },
        },
        inline = {
          adapter = { name = "copilot", model = vim.g.ds_env.copilot_model or "gpt-5" },
          keymaps = {
            accept_change = { modes = { n = "dp" } },
            reject_change = { modes = { n = "de" } },
            always_accept = { modes = { n = "dy" } },
          },
        },
      },
      prompt_library = {
        ["Simplify"] = {
          strategy = "inline",
          description = "Simplify the selected code.",
          opts = {
            modes = { "v" },
            short_name = "simplify",
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "system",
              content = function(ctx)
                return ([[I want you to act as a senior %s developer. I will send you some code,
                and I want you to simplify the code while not diminishing its readability.]]):format(
                  ctx.filetype
                )
              end,
            },
            {
              role = "user",
              content = function(ctx)
                return require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
              end,
              opts = { contains_code = true },
            },
          },
        },
      },
    },
  },
}
