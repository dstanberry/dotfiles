local icons = require "ui.icons"

return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<localleader>gd",
      function()
        local view = require("diffview.lib").get_current_view()
        if view then
          vim.cmd "DiffviewClose"
        else
          vim.cmd "DiffviewOpen"
        end
      end,
      desc = "diffview: toggle diff",
    },
    { "gh", [[:'<'>DiffviewFileHistory<cr>]], mode = "v", desc = "diffview: file history" },
    { "<localleader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview: file history" },
  },
  config = function()
    local actions = require "diffview.actions"
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
        folder_closed = pad(icons.documents.FolderClosed, "right"),
        folder_open = pad(icons.documents.FolderClosed, "right"),
      },
      signs = {
        fold_closed = icons.misc.FoldClosed,
        fold_open = icons.misc.FoldOpened,
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
          local view = lib.get_current_view()
          local file = view.cur_entry
          local target = ""
          if file then
            local layout = file.layout
            if layout:instanceof(Diff2Hor.__get()) or layout:instanceof(Diff2Ver.__get()) then
              if bufnr == layout.a.file.bufnr then
                target = "PREVIOUS"
              elseif bufnr == layout.b.file.bufnr then
                target = "CURRENT"
              end
            elseif layout:instanceof(Diff3.__get()) then
              if bufnr == layout.a.file.bufnr then
                target = "CURRENT"
              elseif bufnr == layout.b.file.bufnr then
                target = "RESULT"
              elseif bufnr == layout.c.file.bufnr then
                target = "INCOMING"
              end
            elseif layout:instanceof(Diff4.__get()) then
              if bufnr == layout.a.file.bufnr then
                target = "CURRENT"
              elseif bufnr == layout.b.file.bufnr then
                target = "RESULT"
              elseif bufnr == layout.c.file.bufnr then
                target = "INCOMING"
              elseif bufnr == layout.d.file.bufnr then
                target = "COMMON ANCESTOR"
              end
            end
            vim.api.nvim_buf_set_var(bufnr, "bufid", "diffview")
            vim.api.nvim_buf_set_var(bufnr, "diffview_label", target)
          end
        end,
      },
      keymaps = {
        diff3 = {
          {
            { "n", "x" },
            "2do",
            actions.diffget "ours",
            { desc = "Obtain the diff hunk from the CURRENT version of the file" },
          },
          {
            { "n", "x" },
            "3do",
            actions.diffget "theirs",
            { desc = "Obtain the diff hunk from the INCOMING version of the file" },
          },
          { "n", "g?", actions.help { "view", "diff3" }, { desc = "Open the help panel" } },
        },
        diff4 = {
          {
            { "n", "x" },
            "1do",
            actions.diffget "base",
            { desc = "Obtain the diff hunk from the COMMON ANCESTOR version of the file" },
          },
          {
            { "n", "x" },
            "2do",
            actions.diffget "ours",
            { desc = "Obtain the diff hunk from the CURRENT version of the file" },
          },
          {
            { "n", "x" },
            "3do",
            actions.diffget "theirs",
            { desc = "Obtain the diff hunk from the INCOMING version of the file" },
          },
          { "n", "g?", actions.help { "view", "diff4" }, { desc = "Open the help panel" } },
        },
        view = { q = diffview.close },
        file_panel = { q = diffview.close },
        file_history_panel = { q = diffview.close },
        option_panel = { q = diffview.close },
      },
    }
    diffview.init()
  end,
}
