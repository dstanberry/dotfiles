return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionHistory" },
    keys = {
      { "<leader>c", mode = { "n", "v" }, "", desc = "+code assistant" },
      { "<leader>ca", mode = { "n", "v" }, ":CodeCompanionActions<cr>", desc = "codecompanion: select action" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "codecompanion: toggle" },
      { "<leader>ch", "<cmd>CodeCompanionHistory<cr>", desc = "codecompanion: show history" },
      { "<leader>cx", mode = { "v" }, "<cmd>CodeCompanionChat Add<cr>", desc = "codecompanion: add selection" },
    },
    init = function()
      local group = ds.augroup "remote.codecompanion"
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
        group = group,
        pattern = "CodeCompanionRequestStarted",
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
        group = group,
        pattern = "CodeCompanionRequestFinished",
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
          fold_reasoning = true,
          intro_message = "",
          diff_window = {
            opts = { winhighlight = "Title:CodeCompanionInlineDiffTitle" },
          },
          window = {
            layout = "vertical",
            width = 82,
            opts = { number = false, relativenumber = false, statuscolumn = " " },
          },
          token_count = function(tokens, _)
            _G.codecompanion_ds_tokens = tokens
            return ""
          end,
        },
      },
      extensions = {
        spinner = {},
        history = { opts = { auto_save = false, keymap = "gh", save_chat_keymap = "gH" } },
      },
      memory = {
        opts = { chat = { enabled = true } },
        devops = {
          description = "Additional collection of instruction files",
          files = {
            ["analysis"] = {
              description = "Analyze the code and provide suggestions for improvements, optimizations, or potential issues",
              files = { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "analysis.md") },
            },
            ["refactor"] = {
              description = "Refactor the code and ensure any associated unit tests are updated if necessary and pass",
              files = { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "refactor.md") },
            },
            [string.format("refactor %s test", ds.icons.misc.ArrowSwap)] = {
              description = "Refactor the code and ensure any associated unit tests are written if necessary and pass",
              files = {
                vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "refactor.md"),
                vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "test.md"),
              },
            },
            ["test"] = {
              description = "Generate unit tests for the given code, ensuring they cover various edge cases and scenarios",
              files = { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "test.md") },
            },
          },
        },
      },
      strategies = {
        chat = {
          adapter = { name = "copilot", model = vim.g.ds_env.copilot_model or "gpt-4.1" },
          keymaps = {
            close = { modes = { n = "q" }, opts = { nowait = true } },
            send = { modes = { n = "<cr>", i = "<c-s>" } },
            stop = { modes = { n = "<c-c>" } },
            next_header = { modes = { n = "]]" } },
            previous_header = { modes = { n = "[[" } },
          },
          roles = {
            llm = function(adapter)
              return string.format("%s %s (%s)", ds.icons.ai.Normal, adapter.formatted_name, adapter.model.name)
            end,
            user = string.format("%s %s", ds.icons.misc.User, (vim.env.USER or "User"):gsub("^%l", string.upper)),
          },
        },
        inline = {
          adapter = { name = "copilot", model = vim.g.ds_env.copilot_model or "gpt-4.1" },
          keymaps = {
            accept_change = { modes = { n = "dp" } },
            reject_change = { modes = { n = "de" } },
            always_accept = { modes = { n = "dy" } },
          },
        },
      },
    },
  },
  {
    "folke/sidekick.nvim",
    keys = {
      { "<tab>", ds.cmp.coalesce { "inline.next", "<tab>" }, mode = { "n" }, expr = true },
      { "<localleader>c", mode = { "n", "v" }, "", desc = "+code assistant" },
      -- stylua: ignore
      { "<localleader>ca", mode = { "n", "v" }, function() require("sidekick.cli").prompt() end, desc = "sidekick: select prompt"},
      { "<localleader>cc", function() require("sidekick.cli").toggle() end, desc = "sidekick: toggle" },
      -- stylua: ignore
      { "<localleader>cx", mode = { "v" }, function() require("sidekick.cli").send() end, desc = "sidekick: add selection" },
    },
    init = function()
      ds.cmp.inline.next = function()
        local nes = require "sidekick.nes"
        if nes.have() and (nes.jump() or nes.apply()) then return true end
      end
    end,
    opts = function()
      return {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        cli = {
          prompts = {
            analyze = {
              msg = ds.fs.read(vim.fs.joinpath(vim.fn.stdpath "config", "prompts/analysis.md"), "r", true),
              diagnostics = true,
            },
            refactor = {
              msg = ds.fs.read(vim.fs.joinpath(vim.fn.stdpath "config", "prompts/refactor.md"), "r", true),
              diagnostics = true,
            },
            tests = {
              msg = ds.fs.read(vim.fs.joinpath(vim.fn.stdpath "config", "prompts/test.md"), "r", true),
              diagnostics = true,
            },
          },
        },
      }
    end,
  },
}
