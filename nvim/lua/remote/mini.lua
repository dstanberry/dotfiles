return {
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        mappings = {
          around = "a",
          inside = "i",
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
          goto_left = nil,
          goto_right = nil,
        },
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- lo[o]ps, c[o]nditions within loop
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}), --[f]unction
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}), -- [c]lass
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- [t]ags (html)
          d = { "%f[%d]%d+" }, -- [d]igits
          e = { -- word with cas[e]
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function(ai_type) -- whole buffer
            local start_line, end_line = 1, vim.fn.line "$"
            if ai_type == "i" then
              -- skip first and last blank lines for `i` textobject
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              -- do nothing for buffer with all blanks
              if first_nonblank == 0 or last_nonblank == 0 then return { from = { line = start_line, col = 1 } } end
              start_line, end_line = first_nonblank, last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
          i = function(ai_type) -- i for indent. "a" is line-wise, "i" is character-wise
            local spaces = (" "):rep(vim.o.tabstop)
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local indents = {}
            for l, line in ipairs(lines) do
              if not line:find "^%s*$" then
                indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match "^%s*", text = line }
              end
            end
            local ret = {}
            for i = 1, #indents do
              if i == 1 or indents[i - 1].indent < indents[i].indent then
                local from, to = i, i
                for j = i + 1, #indents do
                  if indents[j].indent < indents[i].indent then break end
                  to = j
                end
                from = ai_type == "a" and from > 1 and from - 1 or from
                to = ai_type == "a" and to < #indents and to + 1 or to
                ret[#ret + 1] = {
                  indent = indents[i].indent,
                  from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
                  to = { line = indents[to].line, col = #indents[to].text },
                }
              end
            end
            return ret
          end,
          u = ai.gen_spec.function_call(), -- f[u]nction parameter
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- f[u]nction parameter without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      ds.plugin.on_load("which-key.nvim", function()
        local mini_motions = function()
          local motions = {
            { " ", desc = "mini.ai: whitespace" },
            { "'", desc = "mini.ai: ' string" },
            { "(", desc = "mini.ai: () block" },
            { ")", desc = "mini.ai: () block with whitespace" },
            { "<", desc = "mini.ai: <> block" },
            { ">", desc = "mini.ai: <> block with whitespace" },
            { "?", desc = "mini.ai: user prompt" },
            { "[", desc = "mini.ai: [] block" },
            { "]", desc = "mini.ai: [] block with whitespace" },
            { "_", desc = "mini.ai: underscore" },
            { "`", desc = "mini.ai: ` string" },
            { "{", desc = "mini.ai: {} block" },
            { "}", desc = "mini.ai: {} block with whitespace" },
            { '"', desc = 'mini.ai: " string' },
            { "a", desc = "mini.ai: argument" },
            { "b", desc = "mini.ai: )]} block" },
            { "c", desc = "mini.ai: class" },
            { "d", desc = "mini.ai: digit(s)" },
            { "e", desc = "mini.ai: camelCase / snake_case" },
            { "f", desc = "mini.ai: function" },
            { "g", desc = "mini.ai: entire buffer" },
            { "o", desc = "mini.ai: block, conditional, loop" },
            { "q", desc = "mini.ai: quote `\"'" },
            { "t", desc = "mini.ai: tag" },
            { "u", desc = "mini.ai: function use/call" },
            { "U", desc = "mini.ai: function use/call (no dot in function name)" },
          }
          local ret = { mode = { "o", "x" } }
          for prefix, name in pairs(opts.mappings) do
            ret[#ret + 1] = { prefix, group = name }
            for _, obj in ipairs(motions) do
              local desc = obj.desc
              if prefix:sub(1, 1) == "i" then desc = desc:gsub(" with whitespace", "") end
              ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
            end
          end
          require("which-key").add(ret, { notify = false })
        end
        vim.schedule(mini_motions)
      end)
    end,
  },
  {
    "echasnovski/mini.align",
    keys = {
      { "g=", desc = "mini.align: align", mode = { "v", "n" } },
      { "g+", desc = "mini.align: align with preview", mode = { "v", "n" } },
    },
    opts = {
      mappings = {
        start = "g=",
        start_with_preview = "g+",
      },
    },
  },
  {
    "echasnovski/mini.files",
    keys = function()
      local _cwd = function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end
      return {
        { "<localleader>-", _cwd, desc = "mini.files: open parent directory" },
      }
    end,
    opts = {
      options = { use_as_default_explorer = false },
      windows = { preview = false },
      mappings = {
        change_cwd = "gc",
        close = "q",
        go_in = "l",
        go_out = "h",
        go_in_plus = "<cr>",
        go_out_plus = "",
        go_in_vertical = "<c-v>",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        toggle_hidden = "g.",
        trim_left = "<",
        trim_right = ">",
      },
    },
    init = function()
      ds.hl.new("MiniFilesBorder", { link = "FloatBorderSB" })
      ds.hl.new("MiniFilesBorderModified", { fg = vim.g.ds_colors.rose0, bg = vim.g.ds_colors.bg0 })
      ds.hl.new("MiniFilesCursorLine", { bg = vim.g.ds_colors.bg0 })
      ds.hl.new("MiniFilesTitle", { fg = vim.g.ds_colors.gray2, bg = vim.g.ds_colors.bg0 })
      ds.hl.new("MiniFilesTitleFocused", { fg = vim.g.ds_colors.blue1, bg = vim.g.ds_colors.bg0 })
    end,
    config = function(_, opts)
      require("mini.files").setup(opts)

      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
      local show_dotfiles = true

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh { content = { filter = new_filter } }
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require("mini.files").get_target_window()
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in { close_on_file = close_on_file }
          end
        end

        local desc = "mini.files: open in " .. direction .. " split"
        if close_on_file then desc = desc .. " and close" end
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then vim.fn.chdir(cur_directory) end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          local win_id = args.data.win_id

          local config = vim.api.nvim_win_get_config(win_id)
          config.border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end)
          config.title_pos = "center"
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set(
            "n",
            opts.mappings.toggle_hidden,
            toggle_dotfiles,
            { buffer = buf_id, desc = "mini.files: toggle hidden" }
          )
          vim.keymap.set(
            "n",
            opts.mappings.change_cwd,
            files_set_cwd,
            { buffer = args.data.buf_id, desc = "mini.files: set cwd" }
          )

          map_split(buf_id, opts.mappings.go_in_vertical, "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(args) require("remote.lsp.handlers").on_rename(args.data.from, args.data.to) end,
      })
    end,
  },
  {
    "echasnovski/mini.hipatterns",
    event = "LazyFile",
    opts = function(_, opts)
      local hi = require "mini.hipatterns"

      local vtext = ds.pad(ds.icons.misc.FilledCircleLarge, "right")
      local style = "full" -- "full" | "compact"
      local tailwind_colors = require("ft.css.colors").tailwind
      local filetypes = { "css", "html", "javascript", "javascriptreact", "typescript", "typescriptreact" }

      local colors ---@type ColorPalette
      local cache = {} ---@type table<string,table<string,string>>
      local hl_groups = {} ---@type table<string,boolean>

      local get_hl_group = function(hl)
        local group = vim.inspect(hl):gsub("%W+", "_")
        if not hl_groups[group] then
          hl = type(hl) == "string" and { link = hl } or hl
          hl = vim.deepcopy(hl, true)
          hl.fg = hl.fg or vim.g.ds_colors.gray2
          vim.api.nvim_set_hl(0, group, hl)
          hl_groups[group] = true
        end
        return group
      end

      local load_highlights = function(group)
        if cache[group] then return end
        cache[group] = {}
        colors = vim.g.ds_colors
        local highlights = require("theme").defaults(colors)
        for k, v in pairs(highlights) do
          cache[group][k] = get_hl_group(v)
        end
      end

      local get_file = function(buf)
        local fname = vim.api.nvim_buf_get_name(buf or 0)
        fname = vim.fs.normalize(fname)
        if not fname:find "lua/theme" then return end
        return vim.fn.fnamemodify(fname, ":t:r")
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = ds.augroup "mini_hipatterns",
        pattern = "*/lua/theme/**.lua",
        callback = vim.schedule_wrap(function(ev)
          vim.cmd.colorscheme(vim.g.colors_name)
          hl_groups = {}
          local group = get_file(ev.buf)
          if group then cache[group] = nil end
          for _, buf in ipairs(hi.get_enabled_buffers()) do
            hi.update(buf)
          end
        end),
      })

      opts.highlighters = opts.highlighters or {}
      opts.highlighters.nvim_theme = {
        pattern = function(buf)
          local f = get_file(buf)
          if not f then return end
          load_highlights(f)
          return f and '^%s*%[?"?()[%w_%.@]+()"?%]?%s*='
        end,
        group = function(buf, match, _)
          local name = get_file(buf)
          return name and cache[name][match]
        end,
        extmark_opts = { priority = 2000 },
      }
      opts.highlighters.nvim_theme_colors = {
        pattern = {
          "%f[%w]()c%.[%w_%.]+()%f[%W]",
          "%f[%w]()vim%.g%.ds_colors%.[%w_%.]+()%f[%W]",
          "%f[%w]()vim%.g%.terminal_color_%d+()%f[%W]",
        },
        group = function(_, match)
          local parts = vim.split(match, ".", { plain = true })
          local t = _G --[[@as table]]
          if parts[1]:sub(1, 1) == "c" then
            table.remove(parts, 1)
            colors = colors or vim.g.ds_colors
            t = colors
          end
          local color = vim.tbl_get(t, unpack(parts))
          return type(color) == "string" and get_hl_group { fg = color }
        end,
        extmark_opts = function(_, _, data)
          return { virt_text = { { vtext, data.hl_group } }, virt_text_pos = "inline", priority = 2000 }
        end,
      }
      local hex = hi.gen_highlighter.hex_color { priority = 2000, style = "inline", inline_text = vtext }
      opts.highlighters.hex_color = {
        pattern = function(buf)
          local f = get_file(buf)
          if not (f or vim.tbl_contains(filetypes, vim.bo[buf].ft)) then return end
          return hex.pattern()
        end,
        group = hex.group,
        extmark_opts = function(_, _, data)
          return { virt_text = { { vtext, data.hl_group } }, virt_text_pos = "inline", priority = 2000 }
        end,
      }
      opts.highlighters.hex_shorthand = {
        pattern = "()#%x%x%x()%f[^%x%w]",
        group = function(_, _, data)
          ---@type string
          local match = data.full_match
          local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
          local hex_color = "#" .. r .. r .. g .. g .. b .. b

          return MiniHipatterns.compute_hex_color_group(hex_color, "fg")
        end,
        extmark_opts = function(_, _, data)
          return { virt_text = { { vtext, data.hl_group } }, virt_text_pos = "inline", priority = 2000 }
        end,
      }
      opts.highlighters.tailwind = {
        pattern = function(buf)
          if not vim.tbl_contains(filetypes, vim.bo[buf].ft) then return end
          if style == "full" then
            return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
          elseif style == "compact" then
            return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
          end
        end,
        group = function(_, _, data)
          local match = data.full_match
          local color, shade = match:match "[%w-]+%-([a-z%-]+)%-(%d+)"
          shade = tonumber(shade)
          local bg = vim.tbl_get(tailwind_colors, color, shade)
          if bg then
            local hl = "MiniHipatternsTailwind" .. color .. shade
            vim.api.nvim_set_hl(0, hl, { fg = "#" .. bg })
            return hl
          end
        end,
        extmark_opts = function(_, _, data)
          return { virt_text = { { vtext, data.hl_group } }, virt_text_pos = "inline", priority = 2000 }
        end,
      }
    end,
  },
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      style = "glyph",
      -- stylua: ignore
      default = {
        extension = { glyph = "" },
        file      = { glyph = "" },
        filetype  = { glyph = "" },
      },
      -- stylua: ignore
      extension = {
        bash  = { glyph = "", hl = "MiniIconsGreen" },
        md    = { glyph = "", hl = "MiniIconsYellow" },
        mdx   = { glyph = "", hl = "MiniIconsYellow" },
        octo  = { glyph = "", hl = "MiniIconsGrey" },
        zsh   = { glyph = "", hl = "MiniIconsGreen" },
        zshrc = { glyph = "", hl = "MiniIconsGreen" },
      },
      -- stylua: ignore
      file = {
        [".eslintrc.js"]        = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".eslintrc.json"]      = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"]       = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"]         = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.js"]      = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.json"]    = { glyph = "", hl = "MiniIconsPurple" },
        [".zshrc"]              = { glyph = "", hl = "MiniIconsGreen" },
        ["eslint.config.js"]    = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["init.lua"]            = { glyph = "󰢱", hl = "MiniIconsAzure" },
        ["package.json"]        = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.json"]       = { glyph = "", hl = "MiniIconsAzure" },
        zshrc                   = { glyph = "", hl = "MiniIconsGreen" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end

      ds.hl.new("MiniIconsYellow", { fg = vim.g.ds_colors.yellow0 })
      ds.hl.new("MiniIconsPurple", { fg = vim.g.ds_colors.purple0 })
      ds.hl.new("MiniIconsOrange", { fg = vim.g.ds_colors.orange0 })
      ds.hl.new("MiniIconsGreen", { fg = vim.g.ds_colors.green0 })
      ds.hl.new("MiniIconsAzure", { fg = vim.g.ds_colors.aqua0 })
      ds.hl.new("MiniIconsGrey", { fg = vim.g.ds_colors.overlay1 })
      ds.hl.new("MiniIconsCyan", { fg = vim.g.ds_colors.cyan0 })
      ds.hl.new("MiniIconsBlue", { fg = vim.g.ds_colors.blue0 })
      ds.hl.new("MiniIconsRed", { fg = vim.g.ds_colors.rose0 })
    end,
  },
  {
    "echasnovski/mini.pairs",
    event = "LazyFile",
    opts = {
      markdown = true,
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
    },
    config = function(_, opts)
      local pairs = require "mini.pairs"
      pairs.setup(opts)
      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end
        local _o, _c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if opts.markdown and _o == "`" and vim.bo.filetype == "markdown" and before:match "^%s*``" then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next ~= "" and next:match(opts.skip_next) then return _o end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then return _o end
          end
        end
        if opts.skip_unbalanced and next == _c and _c ~= _o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then return _o end
        end
        return open(pair, neigh_pattern)
      end
      vim.api.nvim_create_user_command("PairsDisable", function(args)
        if args.bang then
          vim.b.minipairs_disable = true
        else
          vim.g.minipairs_disable = true
        end
        print "Disabled auto pairs"
      end, {
        desc = "mini.pairs: disable auto pairs",
        bang = true,
      })
      vim.api.nvim_create_user_command("PairsEnable", function()
        vim.b.minipairs_disable = false
        vim.g.minipairs_disable = false
        print "Enabled auto pairs"
      end, {
        desc = "mini.pairs: enable auto pairs",
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "mini.surround: add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "mini.surround: delete surrounding" },
        { opts.mappings.find, desc = "mini.surround: find right surrounding" },
        { opts.mappings.find_left, desc = "mini.surround: find left surrounding" },
        { opts.mappings.highlight, desc = "mini.surround: highlight surrounding" },
        { opts.mappings.replace, desc = "mini.surround: replace surrounding" },
        { opts.mappings.update_n_lines, desc = "mini.surround: update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "ysa",
        delete = "ysd",
        find = "ysf",
        find_left = "ysF",
        highlight = "ysh",
        replace = "ysr",
        update_n_lines = "ysn",
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = {
      { "gJ", desc = "mini.splitjoin: split arguments" },
      { "gj", desc = "mini.splitjoin: join arguments" },
    },
    opts = {
      mappings = {
        toggle = "",
        split = "gJ",
        join = "gj",
      },
    },
    config = function(_, opts) require("mini.splitjoin").setup(opts) end,
  },
}
