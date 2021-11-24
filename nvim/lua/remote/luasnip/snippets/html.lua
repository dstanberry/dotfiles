local luasnip = require "remote.luasnip"

local s = luasnip.snippet
local c = luasnip.choice_node
local fmt = luasnip.extras_fmt.fmt
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local t = luasnip.text_node

local M = {}

M.config = {
  html = {
    s(
      "html",
      fmt(
        [[
        <!DOCTYPE html>
        <html>
        <head>
          <title>{}</title>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1, shrint-to-fit=no"/>
        </head>
        <body>
          {}
        </body>
        </html>]],
        {
          i(1, "Title"),
          i(2, "<!-- body -->"),
        }
      )
    ),
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
  },
}

return M
