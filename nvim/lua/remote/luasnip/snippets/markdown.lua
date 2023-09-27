local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local function repeat_list(_, _, _, prefix)
  if prefix:match "%." then
    local split = vim.split(prefix, ".", { plain = true })
    local num = tonumber(split[1])
    if type(num) == "number" then prefix = ("%s."):format(num + 1) end
  end
  return sn(nil, {
    c(1, {
      t { "" },
      sn(nil, { t { "", prefix .. " " }, i(1), d(2, repeat_list, nil, { user_args = { prefix } }) }),
    }),
  })
end

local make_table = function(_, snip)
  local col = tonumber(snip.captures[1]) or 0
  local row = snip.captures[2] and tonumber(snip.captures[2]) or col
  if row == 0 or col == 0 then
    error "Cannot create table with 0 column or rows"
    return ls.sn(nil, {})
  end
  local nodes = {}
  local node_idx = 0
  local header = {}
  table.insert(header, ls.t "| ")
  for _ = 1, col do
    node_idx = node_idx + 1
    table.insert(header, ls.i(node_idx, "Header"))
    table.insert(header, ls.t " | ")
  end
  table.insert(header, ls.t { "", "" })
  local alignment = {}
  table.insert(alignment, ls.t "| ")
  for _ = 1, col do
    node_idx = node_idx + 1
    table.insert(alignment, ls.c(node_idx, { ls.t ":--- ", ls.t ":---:", ls.t " ---:" }))
    table.insert(alignment, ls.t " | ")
  end
  table.insert(alignment, ls.t { "", "" })
  local body = {}
  for _ = 1, row do
    table.insert(body, ls.t "| ")
    for _ = 1, col do
      node_idx = node_idx + 1
      table.insert(body, ls.i(node_idx, "text"))
      table.insert(body, ls.t " | ")
    end
    table.insert(body, ls.t { "", "" })
  end
  table.insert(body, ls.t { "", "" })
  nodes = vim.list_extend(nodes, header)
  nodes = vim.list_extend(nodes, alignment)
  nodes = vim.list_extend(nodes, body)
  return ls.sn(nil, nodes)
end

return {
  s(
    { trig = "meta", name = "frontmatter", dscr = "Insert yaml formatted metadata" },
    fmt("---\ntitle: {}\ndate: {} {}\ntags: [[{}]]\n---\n\n{}", {
      i(1, "Work in progress"),
      f(function() return os.date "%m/%d/%Y" end, {}),
      f(function() return os.date "%H:%M" end, {}),
      i(2, "fleeting"),
      i(3),
    })
  ),
  s(
    {
      trig = "link",
      name = "markdown link",
      dscr = "Markdown link `[txt](url)`.\nOptional: select text containing `url`, press |`C-x`|, type `'link'`",
    },
    fmt("[{}]({})", {
      i(1),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
  s(
    {
      trig = "img",
      name = "image",
      dscr = "Markdown image `![txt](url)`.\nOptional: select text containing `url`, press |`C-x`|, type `'img'`",
    },
    fmt("![{}]({})", {
      i(1),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
    })
  ),
  s(
    { trig = "tl", name = "task list", dscr = "Task list" },
    fmt("- [{}] {}", {
      d(1, function()
        local options = { " ", "x", "-", "=", "_", "!", "+", "?" }
        for idx = 1, #options do
          options[idx] = t(options[idx])
        end
        return sn(nil, {
          c(1, options),
        })
      end),
      i(2, "item"),
    })
  ),
  s({ trig = "ol", name = "ordered list", dscr = "Unordered list (recursive)" }, {
    t "1. ",
    i(1),
    d(2, repeat_list, nil, { user_args = { "1." } }),
    i(0),
  }),
  s({ trig = "ul", name = "unordered list", dscr = "Unordered list (recursive)" }, {
    t "- ",
    i(1),
    d(2, repeat_list, nil, { user_args = { "-" } }),
    i(0),
  }),
  s({
    trig = "tbl(%d)(%d?)",
    name = "dynamic table",
    dscr = "Dynamic table generation. With maximum of 9 `(cols)` x 9 `(rows)` table",
    regTrig = true,
  }, { d(1, make_table, {}) }),
  postfix({ trig = ".it", name = "italic", dscr = "Italic text" }, { l("*" .. l.POSTFIX_MATCH .. "*") }),
  postfix({ trig = ".bo", name = "bold", dscr = "Bold text" }, { l("**" .. l.POSTFIX_MATCH .. "**") }),
  postfix(
    { trig = ".bi", name = "bold italic", dscr = "Bold and Italic text" },
    { l("***" .. l.POSTFIX_MATCH .. "***") }
  ),
  postfix({
    trig = ".link",
    match_pattern = "%S+$",
    name = "markdown link",
    dscr = "Markdown link `[txt](url)`.\nOptional: select text containing `url`, press |`C-x`|, write the `txt` of link then type `'.link'`",
  }, {
    d(1, function(_, parent)
      local capture = parent.snippet.env.POSTFIX_MATCH
      local link, desc
      if capture:match "http" or capture:match "//" then
        link = i(1, capture)
        desc = d(2, rutil.saved_text, {}, { user_args = { { indent = false } } })
      else
        link = d(2, rutil.saved_text, {}, { user_args = { { indent = false } } })
        desc = i(1, capture)
      end
      return sn(
        nil,
        fmt("[{}]({})", {
          desc,
          link,
        })
      )
    end),
  }),
  postfix({
    trig = ".img",
    match_pattern = "%S+$",
    name = "markdown image",
    dscr = "Markdown image `![txt](url)`.\nOptional: select text containing `url`, press |`C-x`|, write the `txt` of image then type `'.img'`",
  }, {
    d(1, function(_, parent)
      local capture = parent.snippet.env.POSTFIX_MATCH
      local link, desc
      if capture:match "http" or capture:match "//" then
        link = i(1, capture)
        desc = d(2, rutil.saved_text, {}, { user_args = { { indent = false } } })
      else
        link = d(2, rutil.saved_text, {}, { user_args = { { indent = false } } })
        desc = i(1, capture)
      end
      return sn(
        nil,
        fmt("![{}]({})", {
          desc,
          link,
        })
      )
    end),
  }),
}, {
  s(
    { trig = "#([2-6])", regTrig = true, hidden = true, name = "heading", dscr = "Dynamic heading" },
    { f(function(_, snip) return string.rep("#", tonumber(snip.captures[1])) .. " " end, {}) },
    {
      condition = conds.line_begin,
    }
  ),
  s(
    { trig = "```", wordTrig = false, hidden = true, name = "code block", dscr = "Code block" },
    fmt("```{}\n{}\n```\n{}", {
      i(1, "lang"),
      d(2, rutil.saved_text, {}, { user_args = { { indent = false } } }),
      i(0),
    })
  ),
}
