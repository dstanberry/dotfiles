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
      local group = ds.augroup "copilot_notif"
      local sprites = ds.icons.spinners.Default
      local frame_ms, tick_ms = 80, 150

      ---@type table<string, {name:string, msg:string, is_done?:boolean, notify:fun(), timer:uv_timer_t?}>
      local request_cache = {}

      local animate = function()
        local time_ms = math.floor(vim.uv.hrtime() / (1e6 * frame_ms))
        local idx = time_ms % #sprites + 1
        return sprites[idx]
      end

      local get_id = function(ctx)
        local adapter = ctx.data and ctx.data.adapter or {}
        local title = adapter.formatted_name or adapter.name or "Copilot"
        local key = string.format("%s:%s", title, ctx.data and ctx.data.id or "-1")
        return title, key
      end

      local create_notifier = function(key)
        return function()
          local req = request_cache[key]
          if not req then return end
          ds.info(req.msg, {
            id = "copilot_progress",
            title = req.name,
            opts = function(notification) notification.icon = req.is_done and ds.icons.misc.Check or animate() end,
          })
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(ctx)
          if not ctx.data and ctx.adapter and ctx.adapter.name then return end
          local timer = assert(vim.uv.new_timer())
          local title, key = get_id(ctx)
          local notify = create_notifier(key)
          request_cache[key] = { name = title, msg = "Processing...", notify = notify, timer = timer }
          timer:start(0, tick_ms, vim.schedule_wrap(notify))
          notify()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(ctx)
          if not ctx.data and ctx.adapter and ctx.adapter.name then return end
          local _, key = get_id(ctx)
          local req = request_cache[key]
          if not req then return end
          req.is_done = true
          req.msg = ctx.data.status == "success" and "Done" or (ctx.data.status == "error" and "Error") or "Cancelled"
          req.notify()
          request_cache[key] = nil
          if req.timer then
            req.timer:stop()
            req.timer:close()
          end
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
      memory = {
        opts = {
          chat = { enabled = true },
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
