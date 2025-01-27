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
    config = function()
      local diffview = require "diffview"
      local lazy = require "diffview.lazy"
      local lib = lazy.require "diffview.lib"
      local Diff2Hor = lazy.access("diffview.scene.layouts.diff_2_hor", "Diff2Hor")
      local Diff2Ver = lazy.access("diffview.scene.layouts.diff_2_ver", "Diff2Ver")
      local Diff3 = lazy.access("diffview.scene.layouts.diff_3", "Diff3")
      local Diff4 = lazy.access("diffview.scene.layouts.diff_4", "Diff4")

      diffview.setup {
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
        hooks = {
          diff_buf_read = function(bufnr, _)
            vim.opt_local.colorcolumn = ""
            vim.opt_local.relativenumber = false

            local view = lib.get_current_view()
            local file = view.cur_entry
            local target = ""
            if file then
              local layout = file.layout
              if layout:instanceof(Diff2Hor.__get()) or layout:instanceof(Diff2Ver.__get()) then
                if bufnr == layout.a.file.bufnr then
                  target = "Previous"
                elseif bufnr == layout.b.file.bufnr then
                  target = "Current"
                end
              elseif layout:instanceof(Diff3.__get()) then
                vim.api.nvim_buf_set_var(bufnr, "diffview_view", "merge")
                if bufnr == layout.a.file.bufnr then
                  target = "Current"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.a.file.winbar)
                elseif bufnr == layout.b.file.bufnr then
                  target = "Result"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.b.file.winbar)
                elseif bufnr == layout.c.file.bufnr then
                  target = "Incoming"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.c.file.winbar)
                end
              elseif layout:instanceof(Diff4.__get()) then
                vim.api.nvim_buf_set_var(bufnr, "diffview_view", "merge")
                if bufnr == layout.a.file.bufnr then
                  target = "Current"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.a.file.winbar)
                elseif bufnr == layout.b.file.bufnr then
                  target = "Result"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.b.file.winbar)
                elseif bufnr == layout.c.file.bufnr then
                  target = "Incoming"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.c.file.winbar)
                elseif bufnr == layout.d.file.bufnr then
                  target = "Common Ancestor"
                  vim.api.nvim_buf_set_var(bufnr, "diffview_info", layout.d.file.winbar)
                end
              end
              vim.api.nvim_buf_set_var(bufnr, "bufid", "diffview")
              vim.api.nvim_buf_set_var(bufnr, "diffview_label", target)
            end
          end,
        },
        keymaps = {
          view = { q = diffview.close },
          file_panel = { q = diffview.close },
          file_history_panel = { q = diffview.close },
          option_panel = { q = diffview.close },
        },
      }
      diffview.init()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    config = function()
      local signs = require "gitsigns"
      signs.setup {
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
        numhl = false,
        update_debounce = 1000,
        current_line_blame = true,
        current_line_blame_formatter = ds.icons.git.Commit .. " <author>, <author_time:%R>",
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

          local _next = function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              signs.nav_hunk "next"
            end
          end
          local _prev = function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              signs.nav_hunk "prev"
            end
          end

          map("n", "[h", _prev, { desc = "gitsigns: previous hunk" })
          map("n", "[H", function() signs.nav_hunk "first" end, { desc = "gitsigns: goto first hunk" })
          map("n", "]h", _next, { desc = "gitsigns: next hunk" })
          map("n", "]H", function() signs.nav_hunk "last" end, { desc = "gitsigns: goto last hunk" })
          map("n", "<leader>gb", function() signs.blame_line { full = true } end, { desc = "gitsigns: blame line" })
          map("n", "<leader>gp", signs.preview_hunk, { desc = "gitsigns: preview Hunk" })
          map("n", "<leader>gR", signs.reset_buffer, { desc = "gitsigns: reset buffer" })
          map("n", "<leader>gr", signs.reset_hunk, { desc = "gitsigns: reset hunk" })
          map("n", "<leader>gS", signs.stage_buffer, { desc = "gitsigns: stage buffer" })
          map("n", "<leader>gs", signs.stage_hunk, { desc = "gitsigns: stage hunk" })
        end,
      }
    end,
  },
  {
    "pwntester/octo.nvim",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    cmd = "Octo",
    keys = {
      { "<leader>go", function() vim.cmd "Octo" end, desc = "octo: manage github issues and pull requests " },
      -- prefix
      { "<leader>a", "", desc = "octo: +assignee", ft = "octo" },
      { "<leader>c", "", desc = "octo: +comment/code", ft = "octo" },
      { "<leader>l", "", desc = "octo: +label", ft = "octo" },
      { "<leader>i", "", desc = "octo: +issue", ft = "octo" },
      { "<leader>r", "", desc = "octo: +react", ft = "octo" },
      { "<leader>p", "", desc = "octo: +pr", ft = "octo" },
      { "<leader>v", "", desc = "octo: +review", ft = "octo" },
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
      picker = "telescope",
      ssh_aliases = {},
    },
  },
}
