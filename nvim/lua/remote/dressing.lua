return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.select(...)
    end
    -- NOTE: handled by |noice.nvim|
    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- vim.ui.input = function(...)
    --   require("lazy").load { plugins = { "dressing.nvim" } }
    --   return vim.ui.input(...)
    -- end
  end,
  config = function()
    local function get_height(self, _, max_lines)
      local results = #self.finder.results
      local PADDING = 4
      local LIMIT = math.floor(max_lines / 2)
      return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
    end

    require("dressing").setup {
      input = {
        enabled = false,
        insert_only = false,
        title_pos = "left",
        border = "single",
        relative = "editor",
        prefer_width = 60,
        win_options = {
          winblend = 0,
          winhighlight = "NormalFloat:Normal,FloatBorder:DiagnosticInfo",
        },
      },
      select = {
        backend = "telescope",
        telescope = require("telescope.themes").get_dropdown {
          layout_config = { height = get_height },
        },
      },
    }
  end,
}
