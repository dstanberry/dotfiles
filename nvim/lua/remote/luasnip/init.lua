---------------------------------------------------------------
-- => luasnip mappings
---------------------------------------------------------------
local has_luasnip, luasnip = pcall(require, "luasnip")
if not has_luasnip then
  return
end

-- set default options
luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

-- snippet object
local s = luasnip.s
-- insert node
local i = luasnip.i
-- text node
local t = luasnip.t

-- insert a newline
local newline = function(text)
  return t { "", text }
end

-- check if matching (closing) character exists on line
local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, c1, "")
  local _, ct2 = string.gsub(line, c2, "")
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

-- define snippets
local snippets = {}

--stylua: ignore
-- generic snippets
snippets.all = {
  -- autopairs
  s({ trig = "(" }, { t { "(" }, i(1), t { ")" }, i(0) }, neg, char_count_same, "%(", "%)"),
  s({ trig = "{" }, { t { "{" }, i(1), t { "}" }, i(0) }, neg, char_count_same, "%{", "%}"),
  s({ trig = "[" }, { t { "[" }, i(1), t { "]" }, i(0) }, neg, char_count_same, "%[", "%]"),
  s({trig="<"}, { t({"<"}), i(1), t({">"}), i(0) }, neg, char_count_same, '<', '>'),
  s({trig="'"}, { t({"'"}), i(1), t({"'"}), i(0) }, neg, even_count, '\''),
  s({trig="\""}, { t({"\""}), i(1), t({"\""}), i(0) }, neg, even_count, '"'),
  s({trig="{;"}, { t({"{","\t"}), i(1), t({"", "}"}), i(0) }),
}

--stylua: ignore
-- custom lua snippet definitions
snippets.lua = pack {
  ignore = {
    desc = "skip formatting for this section",
    "--stylua: ignore",
  },
  lf = {
    desc = "local a = function(...) end",
    "local ", i(1), " = function(", i(2), ")", newline "  ", i(0), newline "end", },
  fn = {
    desc = "function(...) end",
    "function(", i(1), ")", i(0), newline "end",
  },
}

-- load custom snippets
luasnip.snippets = snippets

local directory = string.format(
  "%s/site/pack/packer/start/",
  vim.fn.stdpath "data"
)

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
