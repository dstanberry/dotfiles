---------------------------------------------------------------
-- => luasnip mappings
---------------------------------------------------------------
local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

-- set default options
luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node

-- insert a newline
local newline = function(text)
  return t { "", text }
end

-- check if matching (closing) character exists on line
local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 == ct2
end

-- check if character exists on line
local function even_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, "")
  return ct % 2 == 0
end

-- negate boolean
local function neg(fn, ...)
  return not fn(...)
end

-- helper function to define static text and placeholders
local shortcut = function(val)
  if type(val) == "string" then
    return { t { val }, i(0) }
  end
  if type(val) == "table" then
    for k, v in ipairs(val) do
      if type(v) == "string" then
        val[k] = t { v }
      end
    end
  end
  return val
end

-- helper function to package snippet objects
local pack = function(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    table.insert(result, (s({ trig = k, dscr = v.desc }, shortcut(v))))
  end
  return result
end

local function part(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end

local function autopair(pair_begin, pair_end, expand_func, ...)
  return s(
    { trig = pair_begin, wordTrig = false },
    { t { pair_begin }, i(1), t { pair_end } },
    { condition = part(expand_func, part(..., pair_begin, pair_end)) }
  )
end

local custom = {}

custom.all = {
  autopair("(", ")", neg, char_count_same),
  autopair("{", "}", neg, char_count_same),
  autopair("[", "]", neg, char_count_same),
  autopair("<", ">", neg, char_count_same),
  autopair("'", "'", neg, even_count),
  autopair('"', '"', neg, even_count),
  autopair("`", "`", neg, even_count),
  s({ trig = "{;" }, { t { "{", "\t" }, i(1), t { "", "}" }, i(0) }),
}

custom.lua = pack {
  ["[[-"] = { "--[[", t { "", "\t" }, i(0), newline "--]]" },
  ["[[;"] = { "[[", t { "", "\t" }, i(0), newline "]]" },
  ig = {
    desc = "skip stylua formatting for this section",
    "-- stylua: ignore",
  },
  fn = {
    desc = "function(...) end",
    "function(",
    i(1),
    ")",
    i(0),
    t { "", "end" },
  },
  lf = {
    desc = "local function a(...) end",
    "local function ",
    i(1),
    "(",
    i(2),
    ")",
    t { "", "\t" },
    i(0),
    t { "", "end" },
  },
  tf = {
    desc = "local a = function(...) end",
    "local ",
    i(1),
    " = function(",
    i(2),
    ")",
    t { "", "\t" },
    i(0),
    t { "", "end" },
  },
}

-- load custom snippets
luasnip.snippets = custom

local directory = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data")

-- list of installed vscode-like plugins
local plugins = {
  "python-snippets",
  "vsc-lua",
  "vim-snippets",
  "vscode-csharp-snippets",
}

-- lazy load snippets from remote plugins
for _, plugin in ipairs(plugins) do
  require("luasnip/loaders/from_vscode").lazy_load {
    paths = { string.format("%s/%s", directory, plugin) },
  }
end

-- load custom keymaps
require "remote.luasnip.keymap"
