local create_keymap = function(capture, start, down)
  local rhs = function()
    local parser = vim.treesitter.get_parser()
    if not parser then return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR) end
    local query = vim.treesitter.query.get(vim.bo.filetype, "textobjects")
    if not query then return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR) end
    local cursor = vim.api.nvim_win_get_cursor(0)
    local locs = {}
    for _, tree in ipairs(parser:trees()) do
      for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
        if query.captures[capture_id] == capture then
          local range = { node:range() } ---@type number[]
          local row = (start and range[1] or range[3]) + 1
          local col = (start and range[2] or range[4]) + 1
          if down and row > cursor[1] or not down and row < cursor[1] then table.insert(locs, { row, col }) end
        end
      end
    end
    return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
  end
  local c = capture:sub(1, 1):lower()
  local lhs = (down and "]" or "[") .. (start and c or c:upper())
  local desc = (down and "next " or "previous ") .. (start and "start" or "end") .. " of " .. capture:gsub("%..*", "")
  if start and c == "c" then
    -- NOTE: preserve builtin keybind to navigate diff chunks
    vim.keymap.set("n", lhs, function()
      if vim.wo.diff then return lhs end
      vim.schedule(function() rhs() end)
      return "<ignore>"
    end, { expr = true, desc = "mini.ai: goto " .. desc .. "/change" })
  else
    vim.keymap.set("n", lhs, rhs, { desc = "mini.ai: goto " .. desc })
  end
end

return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    keys = { { "[f", desc = "mini.ai: goto previous function" }, { "]f", desc = "mini.ai: goto next function" } },
    opts = function()
      local ai = require "mini.ai"

      for _, capture in ipairs { "function.outer", "class.outer" } do
        for _, start in ipairs { true, false } do
          for _, down in ipairs { true, false } do
            create_keymap(capture, start, down)
          end
        end
      end

      return {
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          l = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          ["/"] = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      if require("lazy.core.config").plugins["which-key.nvim"] ~= nil then
        local i = {
          [" "] = "mini.ai: whitespace",
          ['"'] = 'mini.ai: balanced "',
          ["'"] = "mini.ai: balanced '",
          ["`"] = "mini.ai: balanced `",
          ["("] = "mini.ai: balanced (",
          [")"] = "mini.ai: balanced ) including white-space",
          [">"] = "mini.ai: balanced > including white-space",
          ["<lt>"] = "mini.ai: balanced <",
          ["]"] = "mini.ai: balanced ] including white-space",
          ["["] = "mini.ai: balanced [",
          ["}"] = "mini.ai: balanced } including white-space",
          ["{"] = "mini.ai: balanced {",
          ["?"] = "mini.ai: user prompt",
          ["/"] = "mini.ai: comment",
          _ = "mini.ai: underscore",
          a = "mini.ai: argument",
          b = "mini.ai: balanced ), ], }",
          c = "mini.ai: class",
          f = "mini.ai: function",
          l = "mini.ai: block, conditional, loop",
          q = "mini.ai: quote `, \", '",
          t = "mini.ai: tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end
        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs { n = "next", p = "previous" } do
          ---@diagnostic disable-next-line: assign-type-mismatch
          i[key] = vim.tbl_extend("force", { name = "mini.ai: inside " .. name .. " textobject" }, ic)
          ---@diagnostic disable-next-line: assign-type-mismatch
          a[key] = vim.tbl_extend("force", { name = "mini.ai: around " .. name .. " textobject" }, ac)
        end
        require("which-key").register {
          mode = { "o", "x" },
          i = i,
          a = a,
        }
      end
    end,
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = { enable_autocmd = false },
      },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
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
