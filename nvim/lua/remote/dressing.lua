return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.input(...)
    end
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
        insert_only = false,
        border = "single",
        win_options = {
          winblend = 0,
          winhighlight = "NormalFloat:Normal,FloatBorder:Macro",
        },
      },
      select = {
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              backend = "telescope",
              telescope = require("telescope.themes").get_cursor {
                layout_config = { height = get_height },
              },
            }
          end
        end,
        telescope = require("telescope.themes").get_dropdown {
          layout_config = { height = get_height },
        },
      },
    }
  end,
}
