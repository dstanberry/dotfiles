local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local GRAY = color.darken(c.gray, 10)
local GRAY_DARK = color.darken(c.gray, 25)
local BLUE = color.darken(c.blue_dark, 43)

groups.new("TelescopePromptBorder", { fg = GRAY, bg = GRAY })
groups.new("TelescopePreviewBorder", { fg = c.bg_dark, bg = c.bg_dark })
groups.new("TelescopeResultsBorder", { fg = GRAY_DARK, bg = GRAY_DARK })

groups.new("TelescopePromptTitle", { fg = c.bg, bg = c.red, bold = true })
groups.new("TelescopePreviewTitle", { fg = c.bg_dark })
groups.new("TelescopeResultsTitle", { fg = GRAY_DARK })

groups.new("TelescopePromptCounter", { fg = c.gray_light })
groups.new("TelescopePromptPrefix", { fg = c.green })
groups.new("TelescopePromptNormal", { fg = nil, bg = GRAY })
groups.new("TelescopePreviewNormal", { fg = c.green, bg = c.bg_dark })
groups.new("TelescopeResultsNormal", { fg = nil, bg = GRAY_DARK })

groups.new("TelescopeMatching", { fg = c.orange, bold = true })
groups.new("TelescopeMultiSelection", { fg = c.magenta })
groups.new("TelescopeSelection", { fg = nil, bg = BLUE, bold = true })
groups.new("TelescopeSelectionCaret", { fg = c.fg_dark, bg = BLUE, bold = true })

local function current_buffer()
  require("telescope.builtin").current_buffer_fuzzy_find {
    previewer = false,
    prompt_title = "Find in Buffer",
    sorting_strategy = "ascending",
  }
end

local function find_nvim()
  require("telescope.builtin").find_files {
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    cwd = vim.fn.stdpath "config",
    sort_mru = true,
    prompt_title = "Neovim RC Files",
  }
end

local function file_browser()
  local opts
  opts = {
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    prompt_title = "File Browser",
    grouped = true,
    sorting_strategy = "ascending",
  }
  require("telescope").extensions.file_browser.file_browser(opts)
end

local function file_browser_relative()
  local opts
  opts = {
    path = "%:p:h",
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    prompt_title = "File Browser",
    grouped = true,
    sorting_strategy = "ascending",
  }
  require("telescope").extensions.file_browser.file_browser(opts)
end

local function find_plugins()
  require("telescope.builtin").find_files {
    cwd = string.format("%s/lazy", vim.fn.stdpath "data"),
    layout_strategy = "vertical",
    prompt_title = "Remote Plugins",
  }
end

local function grep_last_search()
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")
  require("telescope.builtin").grep_string {
    path_display = { "shorten" },
    search = register,
    word_match = "-w",
  }
end

local function live_grep_args() require("telescope").extensions.live_grep_args.live_grep_args() end

local function oldfiles()
  require("telescope.builtin").oldfiles {
    prompt_title = "Recent Files",
  }
end

local function project_files()
  local opts = {
    follow = has "win32" and false or true,
    hidden = has "win32" and false or true,
    sort_mru = false,
  }
  local git = vim.fs.find ".git"
  if #git >= 1 then
    opts.prompt_title = "Project Files (Git)"
    opts.show_untracked = true
    require("telescope.builtin").git_files(opts)
  else
    opts.prompt_title = "Project Files"
    require("telescope.builtin").find_files(opts)
  end
end

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
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- stylua: ignore
    keys = {
      { "<leader><leader>", project_files, desc = "telescope: find files (project)" },
      { "<leader>f/", grep_last_search, desc = "telescope: find word (last searched)" },
      { "<leader>fb", current_buffer, desc = "telescope: find in buffer" },
      { "<leader>fe", file_browser, desc = "telescope: browse root directory" },
      { "<leader>ff", require("telescope.builtin").find_files, desc = "telescope: find files" },
      { "<leader>fg", require("telescope.builtin").live_grep, desc = "telescope: live grep" },
      { "<leader>fk", require("telescope.builtin").help_tags, desc = "telescope: help pages" },
      { "<leader>fp", find_plugins, desc = "telescope: find files (neovim plugins)" },
      { "<leader>fr", oldfiles, desc = "telescope: find files (recently used)" },
      -- analagous to `<leader>` maps but with customizations
      { "<localleader><leader>", find_nvim, desc = "telescope: find files (neovim config)" },
      { "<localleader>fe", file_browser_relative, desc = "telescope: browse current directory" },
      { "<localleader>fg", live_grep_args, desc = "telescope: find in files (grep with args)" },
      -- lsp handlers
      { "gw", function() require("telescope.builtin").diagnostics { bufnr = 0 } end, desc = "telescope: lsp diagnostics (buffer)" },
      { "gW", require("telescope.builtin").diagnostics, desc = "telescope: lsp diagnostics (workspace)" },
    },
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

      local interactive_rebase = function(prompt_bufnr)
        local commit = state.get_selected_entry().value
        actions.close(prompt_bufnr)
        vim.api.nvim_exec("tabnew | terminal", false)
        local term_channel = vim.opt_local.channel:get()
        vim.api.nvim_chan_send(term_channel, ("git rebase --interactive %s\r"):format(commit))
        vim.cmd.normal "a"
      end

      telescope.setup {
        defaults = {
          prompt_prefix = pad(icons.misc.Prompt, "right"),
          selection_caret = pad(icons.misc.CaretRight, "right"),
          multi_icon = pad(icons.misc.CaretRight, "right"),
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
            horizontal = { preview_width = 0.6 },
            vertical = { preview_height = 0.7 },
          },
          mappings = {
            i = {
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
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        file_ignore_patterns = {
          "%.DAT",
          "%.db",
          "%.DS_Store",
          "%.git",
          "%.gitattributes",
          "%.gpg",
          "%.venv",
          "^node_modules/",
          "^ntuser",
          "git%-crypt",
          "karabiner/assets",
        },
        pickers = {
          buffers = {
            theme = "dropdown",
            sort_mru = true,
            sort_lastused = true,
            show_all_buffers = true,
            ignore_current_buffer = true,
            previewer = false,
            mappings = {
              n = { ["d"] = "delete_buffer" },
            },
          },
          grep_string = {
            layout_config = { height = 30, prompt_position = "top" },
          },
          help_tags = {
            theme = "ivy",
            layout_config = { height = 30, prompt_position = "top" },
          },
          live_grep = {
            layout_strategy = "vertical",
          },
          git_branches = {
            theme = "dropdown",
          },
          git_bcommits = {
            layout_strategy = "vertical",
            mappings = {
              i = {
                ["<c-r>"] = interactive_rebase,
                ["<c-y>"] = copy_commit,
              },
            },
          },
          git_commits = {
            layout_strategy = "vertical",
            mappings = {
              i = {
                ["<c-r>"] = interactive_rebase,
                ["<c-y>"] = copy_commit,
              },
            },
          },
          diagnostics = {
            path_display = { "shorten" },
            layout_strategy = "vertical",
            layout_config = { height = 20 },
          },
          lsp_definitions = {
            theme = "ivy",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_document_symbols = {
            path_display = { "hidden" },
            theme = "ivy",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_dynamic_workspace_symbols = {
            path_display = { "shorten" },
            theme = "ivy",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_references = {
            path_display = { "shorten" },
            theme = "ivy",
            layout_config = { height = 40, prompt_position = "top" },
          },
          lsp_workspace_symbols = {
            path_display = { "shorten" },
            theme = "ivy",
            layout_config = { height = 40, prompt_position = "top" },
          },
          registers = {
            theme = "dropdown",
            layout_config = { height = 40 },
          },
        },
        extensions = {
          file_browser = {
            theme = "ivy",
          },
          fzf = not has "win32" and {
            case_mode = "smart_case",
            override_file_sorter = true,
            override_generic_sorter = false,
          } or {},
          live_grep_args = {
            auto_quoting = true,
            layout_strategy = "vertical",
            mappings = {
              i = {
                ["<c-k>"] = lga_actions.quote_prompt(),
                ["<c-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
              },
            },
          },
          ["ui-select"] = {
            themes.get_cursor {
              previewer = false,
            },
          },
        },
      }
      if not has "win32" then telescope.load_extension "fzf" end
      telescope.load_extension "file_browser"
      telescope.load_extension "gh"
      telescope.load_extension "ui-select"
    end,
    init = function()
      vim.api.nvim_create_user_command("BCommits", require("telescope.builtin").git_bcommits, {})
      vim.api.nvim_create_user_command("Commits", require("telescope.builtin").git_commits, {})
      vim.api.nvim_create_user_command(
        "Buffers",
        function() require("telescope.builtin").buffers { sort_lastused = true } end,
        {}
      )
    end,
  },
}
