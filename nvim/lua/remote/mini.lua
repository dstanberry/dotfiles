return {
  {
    "nvim-mini/mini.ai",
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
          a = ai.gen_spec.argument(), -- object/function [a]rgument
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- [c]lass
          d = { "%f[%d]%d+" }, -- [d]igits
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, --[f]unction
          e = { -- word with cas[e]
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
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
          i = function(ai_type) -- indentation
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
          k = ai.gen_spec.treesitter { -- [k]ey where [k] = v
            a = { "@assignment.outer", "@key.inner" },
            i = { "@assignment.lhs", "@key.inner" },
          },
          o = ai.gen_spec.treesitter { -- lo[o]ps, c[o]nditions within loop
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- html [t]ags
          u = ai.gen_spec.function_call(), -- function [u]sage
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- function [u]sage without dot in function name
          v = ai.gen_spec.treesitter { -- [value] where k = [v]
            a = { "@assignment.outer", "@value.inner", "@return.outer" },
            i = { "@assignment.rhs", "@value.inner", "@return.inner" },
          },
          x = { -- html/[x]ml attribute
            { "<(%w-)%f[^<%w][^<>]->.-</%1>" },
            { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" },
          },
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
    "nvim-mini/mini.align",
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
    "nvim-mini/mini.files",
    keys = function()
      local _cwd = function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end

      return {
        { "<leader>-", _cwd, desc = "mini.files: open parent directory" },
      }
    end,
    opts = {
      options = { use_as_default_explorer = false },
      windows = { preview = false },
      mappings = {
        change_cwd = "<a-c>",
        close = "q",
        go_in = "l",
        go_out = "h",
        go_in_plus = "<cr>",
        go_out_plus = "-",
        go_in_vertical = "<c-v>",
        reset = "<bs>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        toggle_hidden = "<a-h>",
        trim_left = "<",
        trim_right = ">",
      },
    },
    config = function(_, opts)
      local files = require "mini.files"
      files.setup(opts)

      local show_dotfiles = true
      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then vim.fn.chdir(cur_directory) end
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        files.refresh { content = { filter = show_dotfiles and filter_show or filter_hide } }
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target
          local current_target = files.get_explorer_state().target_window
          if current_target ~= nil then
            vim.api.nvim_win_call(current_target, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target = vim.api.nvim_get_current_win()
            end)
            files.set_target_window(new_target)
            files.go_in { close_on_file = close_on_file }
          end
        end
        local desc = ("mini.files: open in %s split"):format(direction)
        if close_on_file then desc = desc .. " and close" end
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local group = ds.augroup "remote.mini_files"
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesActionRename",
        callback = function(args) require("remote.lsp.handlers").on_rename(args.data.from, args.data.to) end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          local m = opts.mappings
          vim.keymap.set("n", "<esc>", files.close, { buffer = buf_id, desc = "mini.files: close explorer" })
          vim.keymap.set("n", m.toggle_hidden, toggle_dotfiles, { buffer = buf_id, desc = "mini.files: toggle hidden" })
          vim.keymap.set("n", m.change_cwd, files_set_cwd, { buffer = args.data.buf_id, desc = "mini.files: set cwd" })
          map_split(buf_id, m.go_in_vertical, "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          local win_id = args.data.win_id
          local config = vim.api.nvim_win_get_config(win_id)
          config.title_pos = "center"
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })
    end,
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "LazyFile",
    opts = function(_, opts)
      local hipatterns = require "mini.hipatterns"

      local vtext = ds.pad(ds.icons.misc.FilledCircleLarge, "right")
      local style = "full" -- "full" | "compact"
      local filetypes = { "css", "html" }

      local cache = {} ---@type table<string,table<string,string>>
      local hl_groups = {} ---@type table<string,boolean>

      local get_hl_group = function(hl)
        local group = vim.inspect(hl):gsub("%W+", "_")
        if not hl_groups[group] then
          hl = type(hl) == "string" and { link = hl } or hl
          hl = vim.deepcopy(hl, true)
          hl.fg = hl.fg or ds.color "gray2"
          if hl.fg == hl.bg then hl.fg = nil end
          vim.api.nvim_set_hl(0, group, hl)
          hl_groups[group] = true
        end
        return group
      end

      local load_highlights = function(group)
        if cache[group] then return end
        cache[group] = {}
        local base = ds.hl.get()
        for k, v in pairs(base) do
          cache[group][k] = get_hl_group(v)
        end
      end

      local get_config_file = function(buf)
        local fname = vim.api.nvim_buf_get_name(buf or 0)
        fname = vim.fs.normalize(fname)
        if not fname:find "lua/theme" then return end
        local base = vim.fs.basename(vim.fs.dirname(fname))
        fname = base .. "_" .. vim.fn.fnamemodify(fname, ":t:r")
        return fname
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = ds.hl.autocmd_group,
        pattern = "*/lua/theme/**.lua",
        callback = vim.schedule_wrap(function(args)
          local group = get_config_file(args.buf) or ""
          hl_groups = {}
          if not group:match "^groups" then return end
          vim.cmd.colorscheme(vim.g.colors_name)
          if group then cache[group] = nil end
          for _, buf in ipairs(hipatterns.get_enabled_buffers()) do
            hipatterns.update(buf)
          end
        end),
      })

      opts.highlighters = opts.highlighters or {}
      opts.highlighters.nvim_hl_groups = {
        pattern = function(buf)
          if not ds.hl.show_preview then return end
          local f = get_config_file(buf)
          if not f then return end
          load_highlights(f)
          if f:match "^groups" then return f and '^%s*%[?"?()[%w_%.@]+()"?%]?%s*=' end
          return f and 'ds%.hl%.add%("?()[%w_%.@]+()"?%)?%s*,'
        end,
        group = function(buf, match, _)
          local name = get_config_file(buf)
          return name and cache[name][match]
        end,
        extmark_opts = { priority = 2000 },
      }
      opts.highlighters.nvim_hl_colors = {
        pattern = {
          "%f[%w]()c%.[%w_%.]+()%f[%W]",
          'ds%.color%("?()[%w_%.@]+()"?%)?%s*',
          'ds%.color%s*"?()[%w_%.@]+()"?%s*',
          "%f[%w]()vim%.g%.ds_colors%.[%w_%.]+()%f[%W]",
          "%f[%w]()vim%.g%.terminal_color_%d+()%f[%W]",
        },
        group = function(_, match)
          local parts = vim.split(match, ".", { plain = true })
          if parts[1]:sub(1, 1) == "c" then table.remove(parts, 1) end
          local color = ds.color(unpack(parts))
          return type(color) == "string" and get_hl_group { fg = color }
        end,
        extmark_opts = function(_, _, data)
          return { virt_text = { { vtext, data.hl_group } }, virt_text_pos = "inline", priority = 2000 }
        end,
      }
      local hex = hipatterns.gen_highlighter.hex_color { priority = 2000, style = "inline", inline_text = vtext }
      opts.highlighters.hex_color = {
        pattern = function(buf)
          local f = get_config_file(buf)
          if not (f or vim.tbl_contains(filetypes, vim.bo[buf].ft) or vim.b.minihipatterns_enabled) then return end
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

          return hipatterns.compute_hex_color_group(hex_color, "fg")
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
          local bg = vim.tbl_get(ds.ft.css.tailwind(), color, shade)
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
    "nvim-mini/mini.icons",
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
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
        [".env"]                = { glyph = "", hl = "MiniIconsYellow" },
        [".env.local"]          = { glyph = "", hl = "MiniIconsGrey" },
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
      -- stylua: ignore
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
      use_file_extension = function(ext, _)
        local _skipped = { "json", "scm", "txt", "yaml", "yml" }
        return not _skipped[ext:lower()]
      end,
    },
  },
  {
    "nvim-mini/mini.operators",
    keys = {
      { "<leader>ss", desc = "mini.operators: apply sort on <pattern>" },
    },
    opts = {
      evaluate = { prefix = "" },
      exchange = { prefix = "" },
      multiply = { prefix = "" },
      replace = { prefix = "" },
      sort = { prefix = "<leader>ss" },
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = "LazyFile",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = false,
    },
    init = function()
      vim.api.nvim_create_user_command("PairsDisable", function(args)
        vim[args.bang and "g" or "b"].minipairs_disable = true
        print "Disabled auto pairs"
      end, { desc = "mini.pairs: disable auto pairs", bang = true })
      vim.api.nvim_create_user_command("PairsEnable", function()
        vim.b.minipairs_disable = false
        vim.g.minipairs_disable = false
        print "Enabled auto pairs"
      end, { desc = "mini.pairs: enable auto pairs" })
    end,
    config = function(_, opts)
      local pairs = require "mini.pairs"
      pairs.setup(opts)
      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" or vim.fn.getcmdpos() >= 1 then return open(pair, neigh_pattern) end
        local _o, _c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if vim.tbl_contains({ "codecompanion", "markdown" }, vim.bo.filetype) then
          if not opts[vim.bo.filetype] then return _o end
          if _o == "`" and before:match "^%s*``" then return "`\n```" .. vim.keycode "<up>" end
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
    end,
  },
  {
    "nvim-mini/mini.splitjoin",
    keys = {
      { "gj", desc = "mini.splitjoin: join arguments" },
      { "gJ", desc = "mini.splitjoin: split arguments" },
    },
    opts = {
      mappings = { toggle = "", split = "gJ", join = "gj" },
    },
  },
  {
    "nvim-mini/mini.surround",
    keys = function(_, keys)
      local opts = ds.plugin.get_opts "mini.surround"
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
        add = "<leader>sa",
        delete = "<leader>sd",
        find = "<leader>sf",
        find_left = "<leader>sF",
        highlight = "<leader>sh",
        replace = "<leader>sr",
        update_n_lines = "<leader>sn",
      },
    },
  },
}
