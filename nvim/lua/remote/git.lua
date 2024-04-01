local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

return {
  {
    "akinsho/git-conflict.nvim",
    lazy = true,
    version = "*",
    opts = {
      default_mappings = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffText",
        current = "DiffAdd",
      },
    },
    {
      "ruifm/gitlinker.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = function()
        local function open(url)
          local Job = require "plenary.job"
          local command
          local args = { url }
          if has "mac" then
            command = "open"
          elseif has "win32" or has "wsl" then
            command = "cmd.exe"
            args = { "/c", "start", url }
          else
            command = "xdg-open"
          end
          Job:new({ command = command, args = args }):start()
        end

        local function browser() return { action_callback = open } end

        return {
          {
            "<localleader>gy",
            function() require("gitlinker").get_buf_range_url "n" end,
            desc = "gitlinker: copy line",
          },
          {
            "<localleader>go",
            function() require("gitlinker").get_buf_range_url("n", browser()) end,
            desc = "gitlinker: open line in browser",
          },
          {
            "<localleader>gy",
            function() require("gitlinker").get_buf_range_url "v" end,
            mode = "v",
            desc = "neogit: copy selection",
          },
          {
            "<localleader>go",
            function() require("gitlinker").get_buf_range_url("v", browser()) end,
            mode = "v",
            desc = "gitlinker: open selection in browser",
          },
        }
      end,
      opts = function()
        local function get_relative_filepath(url_data)
          if has "win32" then
            local git_root = require("gitlinker.git").get_git_root()
            -- use forward slashes only (browser urls don't use backslash char)
            git_root = git_root:gsub("\\", "/")
            url_data.file = url_data.file:gsub("\\", "/")
            -- HACK: trim git root from file to get relative path.. YMMV
            url_data.file = url_data.file:gsub(git_root, "")
            -- trim leading slash
            if url_data.file:sub(1, 1) == "/" then url_data.file = url_data.file:sub(2) end
          end
          return url_data
        end
        local options = {
          mappings = nil,
          callbacks = {
            ["github.com"] = function(url_data)
              url_data = get_relative_filepath(url_data)
              return require("gitlinker.hosts").get_github_type_url(url_data)
            end,
          },
        }
        if vim.g.config_github_enterprise_hostname then
          options.callbacks[vim.g.config_github_enterprise_hostname] = function(url_data)
            url_data = get_relative_filepath(url_data)
            return require("gitlinker.hosts").get_github_type_url(url_data)
          end
        end
        return options
      end,
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      groups.new("GitSignsAdd", { fg = c.green2 })
      groups.new("GitSignsChange", { fg = c.yellow2 })
      groups.new("GitSignsDelete", { fg = c.red1 })
      groups.new("GitSignsChangeDelete", { fg = c.orange0 })
      groups.new("GitSignsCurrentLineBlame", { fg = c.gray1, italic = true })
    end,
    config = function()
      local signs = require "gitsigns"
      signs.setup {
        signs = {
          add = { hl = "GitSignsAdd", text = icons.misc.VerticalBarThin },
          change = { hl = "GitSignsChange", text = icons.misc.VerticalBarThin },
          delete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
          topdelete = { hl = "GitSignsDelete", text = icons.misc.CaretRight },
          changedelete = { hl = "GitSignsDelete", text = icons.misc.VerticalBarSemi },
          untracked = { hl = "GitSignsUntracked", text = icons.misc.VerticalBarSplit },
        },
        status_formatter = function(status)
          local added = ""
          local changed = ""
          local removed = ""
          if status.added and status.added > 0 then added = pad(icons.git.TextAdded, "right") .. status.added end
          if status.changed and status.changed > 0 then
            changed = pad(icons.git.TextChanged, "both") .. status.changed
          end
          if status.removed and status.removed > 0 then
            removed = pad(icons.git.TextRemoved, "both") .. status.removed
          end
          return added .. changed .. removed
        end,
        numhl = false,
        update_debounce = 1000,
        current_line_blame = true,
        current_line_blame_formatter = icons.git.Commit .. " <author>, <author_time:%R>",
        current_line_blame_opts = {
          virt_text = false,
          virt_text_pos = "eol",
          delay = 150,
        },
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]h", signs.next_hunk, { desc = "gitsigns: next hunk" })
          map("n", "[h", signs.prev_hunk, { desc = "gitsigns: previous hunk" })
          map("n", "<leader>gs", signs.stage_hunk, { desc = "gitsigns: stage hunk" })
          map("n", "<leader>gS", signs.stage_buffer, { desc = "gitsigns: stage buffer" })
          map("n", "<leader>gu", signs.undo_stage_hunk, { desc = "gitsigns: unstage Hunk" })
          map("n", "<leader>gr", signs.reset_hunk, { desc = "gitsigns: reset hunk" })
          map("n", "<leader>gR", signs.reset_buffer, { desc = "gitsigns: reset buffer" })
          map("n", "<leader>gp", signs.preview_hunk, { desc = "gitsigns: preview Hunk" })
          map("n", "<leader>gb", signs.toggle_current_line_blame, { desc = "gitsigns: toggle blame line" })
          map("n", "<leader>gB", function() signs.blame_line { full = true } end, { desc = "gitsigns: blame line" })
        end,
      }
    end,
  },
  {
    "polarmutex/git-worktree.nvim",
    event = "VeryLazy",
    config = function()
      local has_telescope, telescope = pcall(require, "telescope")
      if not has_telescope then return end

      local themes = require "telescope.themes"

      require("git-worktree").setup {}
      telescope.load_extension "git_worktree"

      vim.keymap.set(
        "n",
        "<leader>gl",
        function()
          telescope.extensions.git_worktree.git_worktree(themes.get_dropdown {
            previewer = false,
            prompt_title = "Switch to a Git Working Tree",
          })
        end,
        { desc = "git-worktree: switch to a worktree" }
      )

      vim.keymap.set(
        "n",
        "<leader>ga",
        function()
          telescope.extensions.git_worktree.create_git_worktree(themes.get_dropdown {
            previewer = false,
            prompt_title = "Create a Git Working Tree",
          })
        end,
        { desc = "git-worktree: create a worktree" }
      )
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<localleader>gs", function() require("neogit").open { kind = "tab" } end, desc = "neogit: open" },
      { "<localleader>gc", function() require("neogit").open { "commit" } end, desc = "neogit: commit" },
    },
    init = function()
      groups.new("NeogitNotificationInfo", { link = "String" })
      groups.new("NeogitNotificationWarning", { link = "WarningMsg" })
      groups.new("NeogitNotificationError", { link = "ErrorMsg" })

      groups.new("NeogitBranch", { fg = c.green2 })
      groups.new("NeogitRemote", { fg = c.red2 })
      groups.new("NeogitHunkHeader", { fg = color.blend(c.blue4, c.bg2, 0.44), bg = color.blend(c.blue4, c.bg2, 0.05) })
      groups.new("NeogitHunkHeaderHighlight", { fg = c.blue4, bg = color.blend(c.blue4, c.gray0, 0.1) })
      groups.new("NeogitDiffContextHighlight", { fg = c.fg0, bg = c.gray0 })
      groups.new("NeogitDiffAdd", { fg = c.green2, bg = c.diff_add })
      groups.new("NeogitDiffAddHighlight", { fg = c.green2, bg = c.diff_add })
      groups.new("NeogitDiffDeleteHighlight", { fg = c.red1, bg = c.diff_delete })
      groups.new("NeogitObjectId", { fg = color.lighten(c.gray1, 20) })
    end,
    opts = {
      disable_commit_confirmation = true,
      disable_context_highlighting = false,
      disable_insert_on_commit = false,
      commit_popup = {
        kind = "tab",
      },
      signs = {
        hunk = { "", "" },
        item = { icons.misc.FoldClosed, icons.misc.FoldOpened },
        section = { icons.misc.DiagonalExpand, icons.misc.DiagonalShrink },
      },
      integrations = {
        diffview = true,
      },
    },
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Octo",
    keys = {
      { "<leader>go", function() vim.cmd "Octo" end, desc = "octo: manage github issues and pull requests " },
    },
    init = function()
      groups.new("OctoBubble", { link = "Normal" })
      groups.new("OctoEditable", { fg = c.white, bg = color.darken(c.gray0, 10) })
    end,
    opts = {
      use_local_fs = false,
      enable_builtin = true,
      default_to_projects_v2 = false,
      ssh_aliases = {},
      github_hostname = vim.g.config_github_enterprise_hostname or "github.com",
      picker = "telescope",
    },
  },
}
