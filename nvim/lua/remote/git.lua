return {
  {
    "ruifm/gitlinker.nvim",
    keys = function()
      local function open(url)
        local Job = require "plenary.job"
        local command
        local args = { url }
        if ds.has "mac" then
          command = "open"
        elseif ds.has "win32" or ds.has "wsl" then
          command = "cmd.exe"
          args = { "/c", "start", url }
        else
          command = "xdg-open"
        end
        Job:new({ command = command, args = args }):start()
      end

      local _open_line = function() require("gitlinker").get_buf_range_url("n", { action_callback = open }) end
      local _open_range = function() require("gitlinker").get_buf_range_url("v", { action_callback = open }) end
      local _copy_line = function() require("gitlinker").get_buf_range_url "n" end
      local _copy_range = function() require("gitlinker").get_buf_range_url "v" end

      return {
        { "<localleader>gy", _copy_line, desc = "gitlinker: copy line" },
        { "<localleader>gx", _open_line, desc = "gitlinker: open line in browser" },
        { "<localleader>gy", _copy_range, mode = "v", desc = "neogit: copy selection" },
        { "<localleader>gx", _open_range, mode = "v", desc = "gitlinker: open selection in browser" },
      }
    end,
    opts = function()
      local function get_relative_filepath(url_data)
        if ds.has "win32" then
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
      if vim.g.ds_env.github_hostname then
        options.callbacks[vim.g.ds_env.github_hostname] = function(url_data)
          url_data = get_relative_filepath(url_data)
          return require("gitlinker.hosts").get_github_type_url(url_data)
        end
      end
      return options
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    config = function()
      local signs = require "gitsigns"
      signs.setup {
        signs = {
          add = { text = ds.icons.misc.VerticalBarThin },
          change = { text = ds.icons.misc.VerticalBarThin },
          delete = { text = ds.icons.misc.CaretRight },
          topdelete = { text = ds.icons.misc.CaretRight },
          changedelete = { text = ds.icons.misc.VerticalBarSemi },
          untracked = { text = ds.icons.misc.VerticalBarSplit },
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
          map("n", "<leader>gu", signs.undo_stage_hunk, { desc = "gitsigns: unstage Hunk" })
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

      ds.plugin.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.g.ds_cmp_group,
          pattern = "octo",
          callback = function()
            require("cmp").setup.buffer {
              sources = {
                { name = "buffer", keyword_length = 5, max_item_count = 5 },
                { name = "git" },
                { name = "luasnip" },
              },
            }
          end,
        })
      end)
    end,
    opts = function()
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
      return {
        use_local_fs = false,
        enable_builtin = true,
        default_to_projects_v2 = false,
        default_merge_method = "squash",
        github_hostname = vim.g.ds_env.github_hostname or "github.com",
        picker = "telescope",
        ssh_aliases = {},
      }
    end,
  },
}
