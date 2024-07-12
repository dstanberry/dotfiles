return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = function()
      local util = require "remote.telescope.util"
      return {
        -- file
        { "<leader><leader>", util.files.project, desc = "telescope: find files (project)" },
        { "<leader>ff", util.files.default, desc = "telescope: find files" },
        { "<leader>fl", util.files.plugin_spec, desc = "telescope: find files (remote plugin spec)" },
        { "<leader>fp", util.files.plugins, desc = "telescope: find files (remote plugins)" },
        { "<leader>fr", util.files.recent, desc = "telescope: find files (recently used)" },
        { "<localleader><leader>", util.files.nvim_config, desc = "telescope: find files (neovim config)" },
        -- grep
        { "<leader>f/", util.grep.register, desc = "telescope: find word (last searched)" },
        { "<leader>fb", util.grep.buffer, desc = "telescope: find in buffer" },
        { "<leader>fg", util.grep.dynamic, desc = "telescope: live grep" },
        { "<localleader>fg", util.grep.dynamic_args, desc = "telescope: find in files (grep with args)" },
        -- lsp
        { "<leader>fw", util.misc.lsp_buffer_diagnostics, desc = "telescope: lsp diagnostics (buffer)" },
        { "<leader>fW", util.misc.lsp_workspace_diagnostics, desc = "telescope: lsp diagnostics (workspace)" },
        -- tree
        { "<leader>fe", util.browse.project, desc = "telescope: browse project" },
        { "<localleader>fe", util.browse.current_directory, desc = "telescope: browse current directory" },
        -- misc
        { "<leader>fk", util.misc.help_tags, desc = "telescope: help pages" },
      }
    end,
    init = function()
      local GRAY = ds.color.darken(vim.g.ds_colors.gray0, 10)
      local GRAY_DARK = ds.color.darken(vim.g.ds_colors.gray0, 25)
      local BLUE = ds.color.darken(vim.g.ds_colors.blue1, 43)

      ds.hl.new("TelescopePromptBorder", { fg = GRAY, bg = GRAY })
      ds.hl.new("TelescopePreviewBorder", { fg = vim.g.ds_colors.bg0, bg = vim.g.ds_colors.bg0 })
      ds.hl.new("TelescopeResultsBorder", { fg = GRAY_DARK, bg = GRAY_DARK })

      ds.hl.new("TelescopePromptTitle", { fg = vim.g.ds_colors.bg2, bg = vim.g.ds_colors.red1, bold = true })
      ds.hl.new("TelescopePreviewTitle", { fg = vim.g.ds_colors.bg0 })
      ds.hl.new("TelescopeResultsTitle", { fg = GRAY_DARK })

      ds.hl.new("TelescopePromptCounter", { fg = vim.g.ds_colors.gray1 })
      ds.hl.new("TelescopePromptPrefix", { fg = vim.g.ds_colors.green2 })
      ds.hl.new("TelescopePromptNormal", { bg = GRAY })
      ds.hl.new("TelescopePreviewNormal", { fg = vim.g.ds_colors.green2, bg = vim.g.ds_colors.bg0 })
      ds.hl.new("TelescopeResultsNormal", { bg = GRAY_DARK })

      ds.hl.new("TelescopeMatching", { fg = vim.g.ds_colors.orange0, bold = true })
      ds.hl.new("TelescopeMultiSelection", { fg = vim.g.ds_colors.magenta1 })
      ds.hl.new("TelescopeSelection", { bg = BLUE, bold = true })
      ds.hl.new("TelescopeSelectionCaret", { fg = vim.g.ds_colors.fg0, bg = BLUE, bold = true })
    end,
    config = function()
      local telescope = require "telescope"
      local util = require "remote.telescope.util"
      local actions = require "telescope.actions"
      local layout = require "telescope.actions.layout"
      local themes = require "telescope.themes"
      local lga_actions = require "telescope-live-grep-args.actions"

      telescope.setup {
        defaults = {
          set_env = { LESS = "", DELTA_PAGER = "less" },
          prompt_prefix = ds.pad(ds.icons.misc.Prompt, "right"),
          selection_caret = ds.pad(ds.icons.misc.CaretRight, "right"),
          multi_icon = ds.pad(ds.icons.misc.CaretRight, "right"),
          sorting_strategy = "descending",
          results_title = false,
          scroll_strategy = "cycle",
          layout_strategy = "flex",
          cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
          layout_config = {
            width = 0.9,
            horizontal = { preview_width = 0.6 },
            vertical = { preview_height = 0.7 },
          },
          file_ignore_patterns = util.misc.ignore_patterns,
          mappings = {
            i = {
              ["<a-t>"] = util.switch_focus,
              ["<a-y>"] = util.set_prompt_to_entry_value,
              ["<c-down>"] = actions.cycle_history_next,
              ["<c-up>"] = actions.cycle_history_prev,
              ["<c-/>"] = actions.which_key,
              ["<c-d>"] = actions.preview_scrolling_down,
              ["<c-f>"] = actions.preview_scrolling_up,
              ["<c-l>"] = layout.cycle_layout_next,
              ["<c-p>"] = layout.toggle_preview,
              ["<c-t>"] = actions.select_tab,
              ["<c-v>"] = actions.select_vertical,
              ["<c-x>"] = actions.select_horizontal,
              ["<c-n>"] = false,
              ["<c-u>"] = false,
              ["jk"] = actions.close,
              ["<a-q>"] = util.collect_selected,
              ["<c-q>"] = util.collect_all,
            },
            n = {
              ["<a-t>"] = util.switch_focus,
              ["<c-d>"] = actions.preview_scrolling_down,
              ["<c-f>"] = actions.preview_scrolling_up,
              ["yy"] = util.set_prompt_to_entry_value,
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          buffers = {
            theme = "dropdown",
            ignore_current_buffer = true,
            previewer = false,
            show_all_buffers = true,
            sort_lastused = true,
            sort_mru = true,
            mappings = {
              n = { ["d"] = "delete_buffer" },
            },
          },
          find_files = {
            follow = true,
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
            sorting_strategy = "descending",
          },
          git_files = {
            use_git_root = true,
            show_untracked = true,
            recurse_submodules = false,
            sorting_strategy = "descending",
          },
          grep_string = {
            layout_strategy = "vertical",
          },
          help_tags = {
            theme = "ivy",
            layout_config = { height = 30, prompt_position = "top" },
          },
          live_grep = {
            layout_strategy = "vertical",
            mappings = {
              i = { ["<c-f>"] = actions.to_fuzzy_refine },
              n = { ["<c-f>"] = actions.to_fuzzy_refine },
            },
          },
          git_branches = {
            theme = "dropdown",
          },
          git_bcommits = {
            layout_strategy = "vertical",
            mappings = {
              i = { ["<c-y>"] = util.copy_commit },
            },
            previewer = util.git_diff_previewer(),
          },
          git_commits = {
            layout_strategy = "vertical",
            mappings = {
              i = { ["<c-y>"] = util.copy_commit },
            },
            previewer = util.git_commit_previewer(),
          },
          diagnostics = {
            layout_strategy = "vertical",
            path_display = { "shorten" },
          },
          lsp_definitions = {
            reuse_win = true,
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_document_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "hidden" },
          },
          lsp_dynamic_workspace_symbols = {
            symbols = util.lsp_symbols_filter(),
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "shorten" },
            mappings = {
              i = { ["<c-f>"] = actions.to_fuzzy_refine },
              n = { ["<c-f>"] = actions.to_fuzzy_refine },
            },
          },
          lsp_references = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "shorten" },
          },
          lsp_type_definitions = {
            reuse_win = true,
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_workspace_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "shorten" },
          },
          registers = {
            theme = "dropdown",
            layout_config = { height = 40 },
          },
        },
        extensions = {
          file_browser = {
            theme = "ivy",
            grouped = true,
            hidden = true,
            sorting_strategy = "ascending",
          },
          fzf = {
            case_mode = "smart_case",
            override_file_sorter = true,
            override_generic_sorter = false,
          },
          live_grep_args = {
            auto_quoting = true,
            layout_strategy = "vertical",
            mappings = {
              i = {
                ["<c-f>"] = actions.to_fuzzy_refine,
                ["<c-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
                ["<c-k>"] = lga_actions.quote_prompt(),
              },
              n = {
                ["<c-f>"] = actions.to_fuzzy_refine,
                ["<c-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
                ["<c-k>"] = lga_actions.quote_prompt(),
              },
            },
          },
          ["ui-select"] = {
            themes.get_dropdown {
              previewer = false,
              layout_config = {
                height = function(self, _, max_lines)
                  local results = #self.finder.results
                  local PADDING = 4
                  local LIMIT = math.floor(max_lines / 2)
                  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
                end,
                prompt_position = "top",
              },
            },
          },
        },
      }
      telescope.load_extension "file_browser"
      telescope.load_extension "fzf"
      telescope.load_extension "ui-select"
    end,
  },
}
