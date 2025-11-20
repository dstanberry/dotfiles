return {
  {
    "folke/sidekick.nvim",
    keys = function()
      local function _prompt()
        require("sidekick.cli").prompt {
          cb = function(_, text)
            if text then require("sidekick.cli").send { filter = { installed = true }, text = text } end
          end,
        }
      end
      local function _file() require("sidekick.cli").send { filter = { installed = true }, msg = "{file}" } end
      local function _selection() require("sidekick.cli").send { filter = { installed = true }, msg = "{this}" } end
      local function _toggle() require("sidekick.cli").toggle { filter = { installed = true } } end

      return {
        { "<tab>", ds.coalesce({ "cmp.inline.next" }, "<tab>"), mode = { "n" }, expr = true },
        { "<leader>c", mode = { "n", "x" }, "", desc = "+code assistant" },
        { "<leader>ca", mode = { "n", "x" }, _prompt, desc = "sidekick: select prompt" },
        { "<leader>cc", _toggle, desc = "sidekick: toggle" },
        { "<leader>cx", _file, desc = "sidekick: add file" },
        { "<leader>cx", mode = { "x" }, _selection, desc = "sidekick: add selection" },
      }
    end,
    init = function()
      ds.cmp.inline.next = function()
        if not ds.cmp.inline.enabled() then return end
        local nes = require "sidekick.nes"
        if nes.have() and (nes.jump() or nes.apply()) then return true end
      end
    end,
    opts = function()
      return {
        signs = { enabled = true, icon = ds.icons.misc.ArrowCollapseRight },
        cli = {
          mux = { enabled = true, backend = "tmux" },
          context = {
            analyze = function()
              return {
                { "@", "Bold" },
                { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "analyze.md"), "@module" },
              }
            end,
            refactor = function()
              return {
                { "@", "Bold" },
                { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "refactor.md"), "@module" },
              }
            end,
            test = function()
              return {
                { "@", "Bold" },
                { vim.fs.joinpath(vim.fn.stdpath "config", "prompts", "test.md"), "@module" },
              }
            end,
          },
          prompts = {
            analyze = "Review the code for improvements, optimizations, or issues based on the instructions in:\n{analyze}",
            refactor = "Refactor the code based on the instructions in:\n{refactor}",
            tests = "Write or update unit tests based on the instructions in:\n{test}",
          },
          tools = {
            amazon_q = { cmd = { "amazon_q" } },
          },
        },
      }
    end,
  },
}
