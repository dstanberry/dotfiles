---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local M = {}

M.commentstring = function(ctype)
  ctype = ctype or 1
  local commentstring = vim.split(vim.bo.commentstring, "%s", true)
  local left = commentstring[1] and vim.trim(commentstring[1]) or ""
  local right = commentstring[2] and vim.trim(commentstring[2]) or ""
  return { left, right }
end

M.get_case_node = function(index)
  return d(index, function()
    return sn(
      nil,
      fmta("<keyword><condition>:\n\t<body>\n\tbreak;\n\n<continuation>", {
        keyword = t { "case " },
        condition = i(1, "condition"),
        body = d(2, M.saved_text, {}, {
          user_args = { { indent = true, text = " TODO", prefix = function() return M.commentstring(1)[1] end } },
        }),
        continuation = c(3, {
          sn(nil, fmta("\ndefault:\n\t<body>\n", { body = i(1, "break;") }, { dedent = false })),
          vim.deepcopy(M.get_case_node(1)),
        }),
      })
    )
  end, {})
end

M.repeat_node = function(index)
  return f(function(args) return args[1] end, { index })
end

M.repeat_node_segment = function(args, _, _, delim, ext)
  local text = args[1][1] or ""
  if ext then
    local stripped = text:match "(.+)%..+$"
    if stripped then text = stripped end
  end
  local split = vim.split(text, delim, { plain = true })
  local options = {}
  for len = 0, #split - 1 do
    table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
  end
  return sn(nil, { c(1, options) })
end

M.saved_text = function(_, snip, state, user_args)
  local nodes = {}
  state = state or {}
  user_args = user_args or {}
  local indent = user_args.indent and "\t" or ""
  local prefix = user_args.prefix or ""
  if user_args.prefix and type(user_args.prefix) == "function" then prefix = user_args.prefix() end
  if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
    local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
    for idx = 1, #lines do
      local line = string.format("%s%s", indent, lines[idx] or "")
      local node = idx == #lines and { line } or { line, "" }
      table.insert(nodes, t(node))
    end
  else
    local text = string.format("%s%s", prefix, user_args.text or "")
    if indent ~= "" then table.insert(nodes, t(indent)) end
    table.insert(nodes, i(1, text))
  end
  local snip_node = sn(nil, nodes)
  snip_node.old_state = state
  return snip_node
end

return M
