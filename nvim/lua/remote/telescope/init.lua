local build_cmd ---@type string?
for _, cmd in ipairs { "make", "cmake" } do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

return {
  { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  { "nvim-telescope/telescope-symbols.nvim", lazy = true },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
    config = function() require("telescope").load_extension "file_browser" end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
    config = function() require("telescope").load_extension "ui-select" end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = (build_cmd ~= "cmake") and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = build_cmd ~= nil,
        config = function(plugin)
          ds.plugin.on_load("telescope.nvim", function()
            local ok, res = pcall(require("telescope").load_extension, "fzf")
            if not ok then
              local lib = vim.fs.joinpath(plugin.dir, "build", "libfzf." .. ds.has "win32" and "dll" or "so")
              if not vim.uv.fs_stat(lib) then
                require("lazy").build({ plugins = { plugin }, show = false }):wait(
                  function()
                    ds.info(
                      "Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.",
                      { title = "telescope.nvim" }
                    )
                  end
                )
              else
                ds.error(
                  "Failed to load `telescope-fzf-native.nvim`:\n" .. res,
                  { title = "telescope.nvim", ft = "markdown" }
                )
              end
            end
          end)
        end,
      },
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
        { "<leader>fz", util.misc.spell_suggest, desc = "telescope: spelling suggestions" },
      }
    end,
    opts = function()
      local util = require "remote.telescope.util"
      local actions = require "telescope.actions"
      local layout = require "telescope.actions.layout"
      local themes = require "telescope.themes"

      return {
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
          history = { path = vim.fs.joinpath(vim.fn.stdpath "cache", "telescope_history") },
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
            layout_config = { height = 40, prompt_position = "bottom" },
          },
          lsp_document_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "bottom" },
            path_display = { "hidden" },
          },
          lsp_dynamic_workspace_symbols = {
            symbols = util.lsp_symbols_filter(),
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "bottom" },
            path_display = { "shorten" },
            mappings = {
              i = { ["<c-f>"] = actions.to_fuzzy_refine },
              n = { ["<c-f>"] = actions.to_fuzzy_refine },
            },
          },
          lsp_references = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "bottom" },
            path_display = { "shorten" },
          },
          lsp_type_definitions = {
            reuse_win = true,
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "bottom" },
          },
          lsp_workspace_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "bottom" },
            path_display = { "shorten" },
          },
          registers = {
            theme = "dropdown",
            layout_config = { height = 40 },
          },
          spell_suggest = {
            theme = "dropdown",
            layout_config = { height = 15 },
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
                ["<c-k>"] = function(...) require("telescope-live-grep-args.actions").quote_prompt()(...) end,
                ["<c-i>"] = function(...)
                  require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " }(...)
                end,
              },
              n = {
                ["<c-f>"] = actions.to_fuzzy_refine,
                ["<c-k>"] = function(...) require("telescope-live-grep-args.actions").quote_prompt()(...) end,
                ["<c-i>"] = function(...)
                  require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " }(...)
                end,
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
    end,
  },
}
