local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local c = luasnip.choice_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

-- highlight html chunk within this file
vim.treesitter.set_query("lua", "injections", [[
(
	(table
		(field
			(identifier) @_html_identifier_1
			(string) @html))

	(#eq? @_html_identifier_1 "html")
	(#offset! @html 0 2 0 -2)
)
]])

local html_snippets = {
  html = [[<!DOCTYPE html>
<html>
<head>
  <title>${1:Title}</title>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrint-to-fit=no"/>
</head>
<body>
  ${0:}
</body>
</html>]],
}

local snippets = {
  s("script", {
    t "<script",
    c(1, {
      sn(nil, {
        t ' src="',
        i(1, "path/to/file.js"),
        t '">',
      }),
      sn(nil, {
        t { ">", "\t" },
        i(1, "// code"),
        t { "", "" },
      }),
    }),
    i(0),
    t "</script>",
  }),
}

for trig, snip in pairs(html_snippets) do
  snippets[#snippets + 1] = luasnip.parser.parse_snippet(trig, snip)
end

local M = {}

M.config = {
  html = snippets,
}

return M
