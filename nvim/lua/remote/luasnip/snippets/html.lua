---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

return {
  s(
    { trig = "html", name = "docgen", dscr = "HTML scaffold" },
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
        </html>
      ]],
      {
        i(1, "Title"),
        i(2, "<!-- body -->"),
      }
    )
  ),
  s(
    { trig = "script", name = "script", dscr = "Script tag" },
    fmt("{}</script>", {

      c(1, {
        sn(nil, fmt("<script>\n\t{}\n", { i(1, "<!-- TODO -->") }, { trim_empty = false })),
        sn(nil, fmt([[<script src="{}">]], { i(1, "path/to/file.js") })),
      }),
    })
  ),
}
