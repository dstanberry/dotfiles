return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    ft = { "markdown" },
    opts = {
      dash = { width = 80 },
      code = {
        border = "block",
        highlight = "@markup.codeblock",
        highlight_inline = "@markup.raw.markdown_inline",
        left_pad = 2,
        min_width = 80,
        right_pad = 2,
        inline_pad = 1,
        sign = false,
        style = "normal",
        width = "block",
      },
      heading = {
        border = true,
        sign = false,
        width = "block",
        min_width = 80,
        icons = vim.tbl_map(function(i) return ds.pad(ds.icons.markdown["H" .. i], "right") end, vim.fn.range(1, 8)),
      },
    },
  },
}
