local buffer = require "util.buffer"
local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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

      local function browser() return { action_callback = open } end

      return {
        {
          "<localleader>gy",
          function() require("gitlinker").get_buf_range_url "n" end,
          desc = "gitlinker: copy line",
        },
        {
          "<localleader>gx",
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
          "<localleader>gx",
          function() require("gitlinker").get_buf_range_url("v", browser()) end,
          mode = "v",
          desc = "gitlinker: open selection in browser",
        },
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
      if vim.g.config_github_enterprise_hostname then
        options.callbacks[vim.g.config_github_enterprise_hostname] = function(url_data)
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
          if status.added and status.added > 0 then added = ds.pad(icons.git.TextAdded, "right") .. status.added end
          if status.changed and status.changed > 0 then
            changed = ds.pad(icons.git.TextChanged, "both") .. status.changed
          end
          if status.removed and status.removed > 0 then
            removed = ds.pad(icons.git.TextRemoved, "both") .. status.removed
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
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
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
      groups.new("OctoBubble", { link = "Normal" })
      groups.new("OctoEditable", { fg = c.white, bg = color.darken(c.gray0, 10) })

      vim.treesitter.language.register("markdown", "octo")

      ds.on_load("nvim-cmp", function()
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("git-completion", { clear = true }),
          pattern = "octo",
          callback = function()
            ---@diagnostic disable-next-line: missing-fields
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
      local Signs = require "octo.ui.signs"
      local signs = {}

      local unplace = Signs.unplace
      ---@diagnostic disable-next-line: duplicate-set-field
      function Signs.unplace(bufnr)
        signs = vim.tbl_filter(function(s) return s.buf ~= bufnr end, signs)
        return unplace(bufnr)
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      function Signs.place_signs(bufnr, start_line, end_line, is_dirty)
        signs[#signs + 1] = { buf = bufnr, from = start_line, to = end_line, dirty = is_dirty }
      end

      -- stylua: ignore
      local corners = {
        top    = "┌╴",
        middle = "│ ",
        last   = "└╴",
        single = "[ ",
      }

      table.insert(buffer.statuscolumn_signs, function(buf, lnum, vnum, win)
        lnum = lnum - 1
        for _, s in ipairs(signs) do
          if buf == s.buf and lnum >= s.from and lnum <= s.to then
            local height = vim.api.nvim_win_text_height(win, { start_row = s.from, end_row = s.to }).all
            local height_end = vim.api.nvim_win_text_height(win, { start_row = s.to, end_row = s.to }).all
            local corner = corners.middle
            if height == 1 then
              corner = corners.single
            elseif lnum == s.from and vnum == 0 then
              corner = corners.top
            elseif lnum == s.to and vnum == height_end - 1 then
              corner = corners.last
            end
            return { { text = corner, texthl = s.dirty and "OctoDirty" or "IblScope" } }
          end
        end
      end)

      return {
        use_local_fs = false,
        enable_builtin = true,
        default_to_projects_v2 = false,
        default_merge_method = "squash",
        github_hostname = vim.g.config_github_enterprise_hostname or "github.com",
        picker = "telescope",
        ssh_aliases = {},
      }
    end,
  },
}
