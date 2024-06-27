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

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = function()
      -- builtin.buffers
      local function current_buffer()
        require("telescope.builtin").current_buffer_fuzzy_find {
          previewer = false,
          prompt_title = "Find in Buffer",
          sorting_strategy = "ascending",
        }
      end

      -- builtin.find_files
      local function find_nvim()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath "config",
          prompt_title = "Neovim RC Files",
        }
      end

      local function find_plugins()
        require("telescope.builtin").find_files {
          cwd = require("lazy.core.config").options.root,
          layout_strategy = "vertical",
          prompt_title = "Remote Plugins",
        }
      end

      local function find_plugin_configs()
        local files = {}
        for _, plugin in pairs(require("lazy.core.config").plugins) do
          repeat
            if plugin._.module then
              local info = vim.loader.find(plugin._.module)[1]
              if info then files[info.modpath] = info.modpath end
            end
            plugin = plugin._.super
          until not plugin
        end
        require("telescope.builtin").live_grep {
          default_text = "/",
          search_dirs = vim.tbl_values(files),
          prompt_title = "Remote Plugin Configurations",
        }
      end

      local function find_project()
        local git = vim.fs.find(".git", { upward = true })
        if #git >= 1 then
          require("telescope.builtin").git_files {
            prompt_title = "Project Files (Git)",
            show_untracked = true,
          }
        else
          require("telescope.builtin").find_files { prompt_title = "Project Files" }
        end
      end

      -- builtin.grep_string
      local function grep_last_search()
        local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
        require("telescope.builtin").grep_string {
          path_display = { "shorten" },
          search = register,
          word_match = "-w",
        }
      end

      -- builtin.oldfiles
      local function oldfiles()
        require("telescope.builtin").oldfiles {
          prompt_title = "Recent Files",
        }
      end

      -- extensions.live_grep_args
      local function live_grep_args() require("telescope").extensions.live_grep_args.live_grep_args() end

      -- extensions.file_browser
      local function file_browser()
        require("telescope").extensions.file_browser.file_browser { prompt_title = "File Browser" }
      end

      local function file_browser_relative()
        require("telescope").extensions.file_browser.file_browser {
          path = "%:p:h",
          prompt_title = "File Browser",
        }
      end

      -- stylua: ignore
      return {
        { "<leader><leader>", find_project, desc = "telescope: find files (project)" },
        { "<leader>f/", grep_last_search, desc = "telescope: find word (last searched)" },
        { "<leader>fb", current_buffer, desc = "telescope: find in buffer" },
        { "<leader>fe", file_browser, desc = "telescope: browse root directory" },
        { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "telescope: find files" },
        { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "telescope: live grep" },
        { "<leader>fk", function() require("telescope.builtin").help_tags() end, desc = "telescope: help pages" },
        { "<leader>fl", find_plugin_configs, desc = "telescope: find files (remote plugin configurations)" },
        { "<leader>fp", find_plugins, desc = "telescope: find files (neovim plugins)" },
        { "<leader>fr", oldfiles, desc = "telescope: find files (recently used)" },
        -- analagous to `<leader>` maps but with customizations
        { "<localleader><leader>", find_nvim, desc = "telescope: find files (neovim config)" },
        { "<localleader>fe", file_browser_relative, desc = "telescope: browse current directory" },
        { "<localleader>fg", live_grep_args, desc = "telescope: find in files (grep with args)" },
        -- lsp handlers
        { "<leader>fw", function() require("telescope.builtin").diagnostics { bufnr = 0 } end, desc = "telescope: lsp diagnostics (buffer)", },
        { "<leader>fW",function() require("telescope.builtin").diagnostics() end, desc = "telescope: lsp diagnostics (workspace)" },
      }
    end,
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local layout = require "telescope.actions.layout"
      local state = require "telescope.actions.state"
      local themes = require "telescope.themes"

      local lga_actions = require "telescope-live-grep-args.actions"

      local set_prompt_to_entry_value = function(prompt_bufnr)
        local entry = state.get_selected_entry()
        if not entry or not type(entry) == "table" then return end
        state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
      end

      local copy_commit = function(prompt_bufnr)
        local commit = state.get_selected_entry().value
        actions.close(prompt_bufnr)
        vim.fn.setreg("+", commit)
        vim.defer_fn(
          function() vim.notify(("'%s' copied to clipboard"):format(commit), nil, { timeout = 500 }) end,
          500
        )
      end

      telescope.setup {
        defaults = {
          set_env = {
            LESS = "",
            DELTA_PAGER = "less",
          },
          prompt_prefix = ds.pad(vim.g.ds_icons.misc.Prompt, "right"),
          selection_caret = ds.pad(vim.g.ds_icons.misc.CaretRight, "right"),
          multi_icon = ds.pad(vim.g.ds_icons.misc.CaretRight, "right"),
          sorting_strategy = "descending",
          results_title = false,
          scroll_strategy = "cycle",
          layout_strategy = "flex",
          cycle_layout_list = {
            "flex",
            "horizontal",
            "vertical",
            "bottom_pane",
            "center",
          },
          layout_config = {
            width = 0.9,
            horizontal = { preview_width = 0.6 },
            vertical = { preview_height = 0.7 },
          },
          file_ignore_patterns = {
            "%.DAT",
            "%.db",
            "%.DS_Store",
            "%.git",
            "%.gitattributes",
            "%.gpg",
            "%.venv/",
            "^%.git%-crypt/",
            "^node_modules/",
            "^ntuser",
            "^venv/",
          },
          mappings = {
            i = {
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
              ["<c-y>"] = set_prompt_to_entry_value,
              ["<c-n>"] = false,
              ["<c-u>"] = false,
              ["jk"] = actions.close,

              -- plugin integrations
              ["<c-q>"] = function(...)
                if package.loaded["trouble"] then
                  return require("trouble.sources.telescope").open(...)
                else
                  return actions.send_to_qflist(...) + actions.open_qflist(...)
                end
              end,
              ["<a-q>"] = function(...)
                if package.loaded["trouble"] then
                  return require("trouble.sources.telescope").open(...)
                else
                  return actions.send_selected_to_qflist(...) + actions.open_qflist(...)
                end
              end,
            },
            n = {
              ["<c-d>"] = actions.preview_scrolling_down,
              ["<c-f>"] = actions.preview_scrolling_up,
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
              i = { ["<c-y>"] = copy_commit },
            },
            previewer = require("telescope.previewers").new_termopen_previewer {
              get_command = function(entry)
                local shell = ds.has "win32" and "pwsh" or "zsh"
                local flags = ds.has "win32" and "-Command" or "-c"
                local nullpipe = ds.has "win32" and "Nul" or "/dev/null"
                return {
                  shell,
                  flags,
                  table.concat({
                    "git diff",
                    table.concat { entry.value, "~:", vim.fn.expand "#" },
                    table.concat { entry.value, ":", vim.fn.expand "#" },
                    "2> " .. nullpipe .. " || git show",
                    table.concat { entry.value, ":", vim.fn.expand "#" },
                  }, " "),
                }
              end,
            },
          },
          git_commits = {
            layout_strategy = "vertical",
            mappings = {
              i = { ["<c-y>"] = copy_commit },
            },
            previewer = require("telescope.previewers").new_termopen_previewer {
              get_command = function(entry)
                local shell = ds.has "win32" and "pwsh" or "zsh"
                local flags = ds.has "win32" and "-Command" or "-c"
                return {
                  shell,
                  flags,
                  table.concat({
                    "git diff",
                    entry.value,
                  }, " "),
                }
              end,
            },
          },
          diagnostics = {
            layout_strategy = "vertical",
            path_display = { "shorten" },
          },
          lsp_definitions = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_document_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "hidden" },
          },
          lsp_dynamic_workspace_symbols = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "shorten" },
          },
          lsp_references = {
            layout_strategy = "vertical",
            layout_config = { height = 40, prompt_position = "top" },
            path_display = { "shorten" },
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
              layout_config = {
                height = function(self, _, max_lines)
                  local results = #self.finder.results
                  local PADDING = 4
                  local LIMIT = math.floor(max_lines / 2)
                  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
                end,
                prompt_position = "top",
              },
              previewer = false,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopePrompt",
        callback = function() vim.opt_local.cursorline = false end,
      })

      local function git_hunks()
        require("telescope.pickers")
          .new({
            finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
              entry_maker = function(line)
                local filename, lnum_string = line:match "([^:]+):(%d+).*"
                if filename:match "^/dev/null" then return nil end
                return {
                  value = filename,
                  display = line,
                  ordinal = line,
                  filename = filename,
                  lnum = tonumber(lnum_string),
                }
              end,
            }),
            sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
            previewer = require("telescope.config").values.grep_previewer {},
            results_title = "Git Hunks",
            prompt_title = "Git Hunks",
            layout_strategy = "flex",
          }, {})
          :find()
      end

      vim.api.nvim_create_user_command("Hunks", git_hunks, {})
      vim.api.nvim_create_user_command("BCommits", require("telescope.builtin").git_bcommits, {})
      vim.api.nvim_create_user_command("Commits", require("telescope.builtin").git_commits, {})
      vim.api.nvim_create_user_command(
        "Buffers",
        function() require("telescope.builtin").buffers { sort_lastused = true } end,
        {}
      )

      telescope.load_extension "file_browser"
      telescope.load_extension "fzf"
      telescope.load_extension "gh"
      telescope.load_extension "ui-select"
    end,
  },
}
