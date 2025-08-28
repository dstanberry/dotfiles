return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = function()
      local _toggle = function()
        local action = require("diffview.lib").get_current_view() and "Close" or "Open"
        vim.cmd("Diffview" .. action)
      end

      return {
        { "<localleader>gd", _toggle, desc = "diffview: toggle diff" },
        { "<localleader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview: file history" },
        { "<localleader>gh", ":'<'>DiffviewFileHistory<cr>", desc = "diffview: file history", mode = "v" },
      }
    end,
    opts = {
      diff_binaries = false,
      use_icons = true,
      enhanced_diff_hl = true,
      icons = {
        folder_closed = ds.pad(ds.icons.documents.FolderOutlineClosed, "right"),
        folder_open = ds.pad(ds.icons.documents.FolderOutlineClosed, "right"),
      },
      signs = {
        fold_closed = ds.icons.misc.FoldClosed,
        fold_open = ds.icons.misc.FoldOpened,
      },
      view = {
        default = { layout = "diff2_horizontal" },
        file_history = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "left",
          width = 35,
          height = 10,
          win_opts = { winhighlight = "Normal:NormalSB" },
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          width = 35,
          height = 20,
          win_opts = { winhighlight = "Normal:NormalSB" },
        },
      },
      keymaps = {
        view = { q = function() return require("diffview").close() end },
        file_panel = { q = function() return require("diffview").close() end },
        file_history_panel = { q = function() return require("diffview").close() end },
        option_panel = { q = function() return require("diffview").close() end },
      },
      hooks = {
        diff_buf_read = function(bufnr, _)
          local lazy = require "diffview.lazy"
          local lib = lazy.require "diffview.lib"
          local view = lib.get_current_view()

          if not view.cur_entry then return end

          local layout = view.cur_entry.layout
          local layouts = setmetatable({}, {
            __index = function(t, key)
              local path = key:gsub("(%d)", "_%1_"):gsub("_$", ""):lower()
              local diffview_layout = lazy.access("diffview.scene.layouts." .. path, key)
              rawset(t, key, diffview_layout.__get())
              return t[key]
            end,
          })

          local function set_buf_vars(buf, view_type, label, winbar)
            vim.api.nvim_buf_set_var(buf, "diffview_label", label)
            vim.api.nvim_buf_set_var(buf, "diffview_view", view_type)
            if winbar then vim.api.nvim_buf_set_var(buf, "diffview_info", winbar) end
          end

          vim.opt_local.colorcolumn = ""
          vim.opt_local.relativenumber = false
          vim.api.nvim_buf_set_var(bufnr, "bufid", "diffview")

          if layout:instanceof(layouts.Diff2Hor) or layout:instanceof(layouts.Diff2Ver) then
            vim.api.nvim_buf_set_var(bufnr, "diffview_label", bufnr == layout.a.file.bufnr and "Previous" or "Current")
          elseif layout:instanceof(layouts.Diff3) or layout:instanceof(layouts.Diff4) then
            local files = { layout.a.file, layout.b.file, layout.c and layout.c.file, layout.d and layout.d.file }
            local labels = { "Current", "Result", "Incoming", layout:instanceof(layouts.Diff4) and "Common Ancestor" }

            for i, f in ipairs(files) do
              if f and bufnr == f.bufnr then
                set_buf_vars(bufnr, "merge", labels[i], f.winbar)
                break
              end
            end
          end
        end,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    version = "*",
    event = "LazyFile",
    opts = {
      numhl = false,
      update_debounce = 1000,
      current_line_blame = true,
      current_line_blame_formatter = ds.icons.git.Commit .. " <author>, <author_time:%R>",
      current_line_blame_opts = { virt_text = false, virt_text_pos = "eol", delay = 150 },
      signs = {
        add = { text = ds.icons.misc.VerticalBarMiddle },
        change = { text = ds.icons.misc.VerticalBarMiddle },
        delete = { text = ds.icons.misc.CaretRight },
        topdelete = { text = ds.icons.misc.CaretRight },
        changedelete = { text = ds.icons.misc.VerticalBarSemi },
        untracked = { text = ds.icons.misc.VerticalBarMiddleDashed },
      },
      status_formatter = function(status)
        local added = ""
        local changed = ""
        local removed = ""
        if status.added and status.added > 0 then added = ds.pad(ds.icons.git.TextAdded, "right") .. status.added end
        if status.changed and status.changed > 0 then
          changed = ds.pad(ds.icons.git.TextChanged, "both") .. status.changed
        end
        if status.removed and status.removed > 0 then
          removed = ds.pad(ds.icons.git.TextRemoved, "both") .. status.removed
        end
        return added .. changed .. removed
      end,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

        local _next = function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gs.nav_hunk "next"
          end
        end
        local _prev = function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gs.nav_hunk "prev"
          end
        end

        map("n", "[h", _prev, "gitsigns: previous hunk")
        map("n", "]h", _next, "gitsigns: next hunk")
        map("n", "[H", function() gs.nav_hunk "first" end, "gitsigns: goto first hunk")
        map("n", "]H", function() gs.nav_hunk "last" end, "gitsigns: goto last hunk")
        map("n", "<localleader>gb", function() gs.blame_line { full = true } end, "gitsigns: blame line")
        map("n", "<localleader>gp", gs.preview_hunk, "gitsigns: preview Hunk")
        map("n", "<localleader>gr", gs.reset_hunk, "gitsigns: reset hunk")
        map("n", "<localleader>gR", gs.reset_buffer, "gitsigns: reset buffer")
        map("n", "<localleader>gs", gs.stage_hunk, "gitsigns: stage hunk")
        map("n", "<localleader>gS", gs.stage_buffer, "gitsigns: stage buffer")
      end,
    },
  },
  {
    "pwntester/octo.nvim",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    cmd = "Octo",
    keys = {
      { "<leader>gp", function() vim.cmd "Octo pr list" end, desc = "octo: list pull requests" },
      { "<leader>gP", function() vim.cmd "Octo pr search" end, desc = "octo: search pull requests" },
      -- prefix
      { "<localleader>a", "", desc = "octo: +assignee", ft = "octo" },
      { "<localleader>c", "", desc = "octo: +comment/code", ft = "octo" },
      { "<localleader>l", "", desc = "octo: +label", ft = "octo" },
      { "<localleader>i", "", desc = "octo: +issue", ft = "octo" },
      { "<localleader>r", "", desc = "octo: +react", ft = "octo" },
      { "<localleader>p", "", desc = "octo: +pull request", ft = "octo" },
      { "<localleader>pr", "", desc = "octo: +rebase", ft = "octo" },
      { "<localleader>ps", "", desc = "octo: +squash", ft = "octo" },
      { "<localleader>v", "", desc = "octo: +review", ft = { "octo", "octo_panel" } },
      { "<localleader>g", "", desc = "octo: +go to issue", ft = "octo" },
      -- trigger completion menu
      { "@", "@<c-x><c-o>", mode = "i", ft = "octo", silent = true },
      { "#", "#<c-x><c-o>", mode = "i", ft = "octo", silent = true },
    },
    init = function()
      vim.treesitter.language.register("markdown", "octo")
      vim.api.nvim_create_autocmd("ExitPre", {
        group = ds.augroup "octo_exitpre",
        callback = function()
          local keep = { "octo" }
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.tbl_contains(keep, vim.bo[buf].filetype) then vim.bo[buf].buftype = "" end
          end
        end,
      })
    end,
    opts = {
      use_local_fs = false,
      enable_builtin = true,
      default_to_projects_v2 = false,
      default_merge_method = "squash",
      github_hostname = vim.g.ds_env.github_hostname or "github.com",
      picker = "snacks",
      ssh_aliases = {},
    },
  },
}
