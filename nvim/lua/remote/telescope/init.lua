local util = require "remote.telescope.util"

local build_cmd ---@type string?
for _, cmd in ipairs { "make", "cmake" } do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

return {
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
    opts = function()
      local actions = require "telescope.actions"
      local layout = require "telescope.actions.layout"

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
              ["<c-q>"] = util.collect_available,
              ["<c-n>"] = false,
              ["<c-u>"] = false,
              ["jk"] = actions.close,
            },
            n = {
              ["<c-d>"] = actions.preview_scrolling_down,
              ["<c-f>"] = actions.preview_scrolling_up,
              ["/"] = util.toggle_focus,
              ["q"] = actions.close,
              ["yy"] = util.set_prompt_to_entry_value,
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
              i = { ["<c-g>"] = actions.to_fuzzy_refine },
              n = { ["<c-g>"] = actions.to_fuzzy_refine },
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
              i = { ["<c-g>"] = actions.to_fuzzy_refine },
              n = { ["<c-g>"] = actions.to_fuzzy_refine },
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
            symbols = util.lsp_symbols_filter(),
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
          fzf = {
            case_mode = "smart_case",
            override_file_sorter = true,
            override_generic_sorter = false,
          },
        },
      }
    end,
  },
}
