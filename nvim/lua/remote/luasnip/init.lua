-- verify luasnip is available
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

local s = luasnip.snippet
local c = luasnip.choice_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node
local types = require "luasnip.util.types"

-- set default options
luasnip.config.setup {
  history = true,
  enable_autosnippets = true,
  updateevents = "InsertLeave",
  region_check_events = "CursorHold",
  delete_check_events = "TextChanged",
  store_selection_keys = "<tab>",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "choiceNode", "Comment" } },
      },
    },
  },
}

local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 == ct2
end

local function even_count(char)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, char, "")
  return ct % 2 == 0
end

local function autopair(pair_begin, pair_end, ...)
  local function negate(fn, ...)
    return not fn(...)
  end
  local function part(func, ...)
    local args = { ... }
    return function()
      return func(unpack(args))
    end
  end
  return s(
    { trig = pair_begin, wordTrig = false },
    { t { pair_begin }, i(1), t { pair_end } },
    { condition = part(negate, part(..., pair_begin, pair_end)) }
  )
end

luasnip.snippets = {
  all = {
    autopair("(", ")", char_count_same),
    autopair("{", "}", char_count_same),
    autopair("[", "]", char_count_same),
    autopair("<", ">", char_count_same),
    autopair("'", "'", even_count),
    autopair('"', '"', even_count),
    autopair("`", "`", even_count),
    s({ trig = "{;", wordTrig = false }, { t { "{", "\t" }, i(1), t { "", "}" }, i(0) }),
  },
  lua = {
    s({ trig = "[[-", wordTrig = false }, {
      t "--[[",
      t { "", "\t" },
      i(0),
      t { "", "--]]" },
    }),
    s({ trig = "[[;", wordTrig = false }, {
      t "[[",
      t { "", "\t" },
      i(0),
      t { "", "]]" },
    }),
    s({ trig = "ig", wordTrig = true }, {
      t "-- stylua: ignore",
    }),
    s({ trig = "fn", wordTrig = true }, {
      t "function(",
      i(1),
      t ")",
      i(0),
      t { "", "end" },
    }),
    s({ trig = "lf", wordTrig = true }, {
      t "local function ",
      i(1),
      t "(",
      i(2),
      t ")",
      t { "", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "tf", wordTrig = true }, {
      t "local ",
      i(1),
      t " = function(",
      i(2),
      t ")",
      t { "", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "if", wordTrig = true }, {
      t "if ",
      i(1),
      t { " then", "\t" },
      i(0),
      t { "", "end" },
    }),
    s({ trig = "for", wordTrig = true }, {
      t "for ",
      c(1, {
        sn(nil, { i(1, "k"), t ", ", i(2, "v"), t " in ", c(3, { t "pairs", t "ipairs" }), t "(", i(4), t ")" }),
        sn(nil, { i(1, "i"), t " = ", i(2), t ", ", i(3) }),
      }),
      t { " do", "\t" },
      i(0),
      t { "", "end" },
    }),
  },
}

local plugins = {
  "python-snippets",
  "vsc-lua",
  "vim-snippets",
  "vscode-csharp-snippets",
}

local directory = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data")
for _, plugin in ipairs(plugins) do
  require("luasnip/loaders/from_vscode").lazy_load {
    paths = { string.format("%s/%s", directory, plugin) },
  }
end
