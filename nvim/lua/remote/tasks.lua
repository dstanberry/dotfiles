return {
  "dstanberry/vs-tasks.nvim",
  name = "vstask",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "LazyFile",
  keys = function()
    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return {} end

    local themes = require "telescope.themes"

    local show_tasks = function()
      telescope.extensions.vstask.tasks(themes.get_dropdown {
        previewer = false,
        prompt_title = "Launch Task",
      })
    end

    return {
      { "<leader>ft", show_tasks, desc = "telescope: show vscode tasks" },
    }
  end,
  opts = {
    config_dir = ".vscode",
    -- json_parser = vim.json.decode,
    cache_json_conf = true,
    cache_strategy = "last",
    terminal = "toggleterm",
    term_opts = {
      current = {
        direction = "float",
      },
      tab = {
        direction = "tab",
      },
    },
    telescope_keys = {
      tab = "<c-t>",
      current = "<cr>",
    },
  },
}
