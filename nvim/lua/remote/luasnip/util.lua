local luasnip = require "luasnip"

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

local M = {}

M.comment_string = function()
  local cstring = vim.split(vim.bo.commentstring, "%s", true)[1]
  if cstring == "/*" then
    cstring = "//"
  end
  return vim.trim(cstring)
end

M.autopair = {}

M.autopair.create = function(pair_begin, pair_end, ...)
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
    { trig = pair_begin, wordTrig = false, hidden = true },
    { t { pair_begin }, i(1), t { pair_end } },
    { condition = part(negate, part(..., pair_begin, pair_end)) }
  )
end

M.autopair.punctuation_matched = function(c1, c2)
  local line = vim.api.nvim_get_current_line()
  local _, ct1 = string.gsub(line, "%" .. c1, "")
  local _, ct2 = string.gsub(line, "%" .. c2, "")
  return ct1 == ct2
end

M.autopair.char_matched = function(char)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, char, "")
  return ct % 2 == 0
end

local case_node
local function get_case_node(index)
  return d(index, function()
    return sn(
      nil,
      fmta("<keyword><condition>:\n\t<body>\n\tbreak;\n\n<continuation>", {
        keyword = t { "case " },
        condition = i(1, "condition"),
        body = d(
          2,
          M.saved_text,
          {},
          { user_args = { { text = ("%s TODO"):format(M.comment_string), indent = false } } }
        ),
        continuation = c(3, {
          sn(
            nil,
            fmta("\ndefault:\n\t<body>\n", { body = i(1, ("%s TODO"):format(M.comment_string)) }, { dedent = false })
          ),
          vim.deepcopy(case_node),
        }),
      })
    )
  end, {})
end
case_node = get_case_node(1)

M.switch_case_node = fmta("<keyword> (<expression>) {\n<case>\n}", {
  keyword = t "switch",
  expression = i(1, "expression"),
  case = isn(2, { t "\t", get_case_node(1) }, "$PARENT_INDENT\t"),
})

M.repeat_node = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

M.repeat_node_segment = function(args, _, _, delim, ext)
  local text = args[1][1] or ""
  if ext then
    local stripped = text:match "(.+)%..+$"
    if stripped then
      text = stripped
    end
  end
  local split = vim.split(text, delim, { plain = true })
  local options = {}
  for len = 0, #split - 1 do
    table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
  end
  return sn(nil, {
    c(1, options),
  })
end

M.saved_text = function(_, snip, old_state, user_args)
  local nodes = {}
  old_state = old_state or {}
  user_args = user_args or {}
  local indent = user_args.indent and "\t" or ""
  if snip.snippet.env and snip.snippet.env.SELECT_DEDENT and #snip.snippet.env.SELECT_DEDENT > 0 then
    local lines = vim.deepcopy(snip.snippet.env.SELECT_DEDENT)
    for idx = 1, #lines do
      local line = indent .. lines[idx]
      local node = idx == #lines and { line } or { line, "" }
      table.insert(nodes, t(node))
    end
  else
    local text = user_args.text or ""
    if indent ~= "" then
      table.insert(nodes, t(indent))
    end
    table.insert(nodes, i(1, text))
  end
  local snip_node = sn(nil, nodes)
  snip_node.old_state = old_state
  return snip_node
end

local function find_dynamic_node(node)
  while not node.dynamicNode do
    node = node.parent
  end
  return node.dynamicNode
end

local external_update_id = 0
M.dynamic_node_external_update = function(func_indx)
  local current_node = luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
  local dynamic_node = find_dynamic_node(current_node)
  external_update_id = external_update_id + 1
  current_node.external_update_id = external_update_id
  local insert_pre_call = vim.fn.mode() == "i"
  local cursor_pos_pre_relative = util.pos_sub(util.get_cursor_0ind(), current_node.mark:pos_begin_raw())
  dynamic_node.snip:store()
  node_util.leave_nodes_between(dynamic_node.snip, current_node)
  local func = dynamic_node.user_args[func_indx]
  if func then
    func(dynamic_node.parent.snippet)
  end
  dynamic_node.last_args = nil
  dynamic_node:update()
  local target_node = dynamic_node:find_node(function(test_node)
    return test_node.external_update_id == external_update_id
  end)
  if target_node then
    node_util.enter_nodes_between(dynamic_node, target_node, true)
    if insert_pre_call then
      util.set_cursor_0ind(util.pos_add(target_node.mark:pos_begin_raw(), cursor_pos_pre_relative))
    else
      node_util.select_node(target_node)
    end
    luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] = target_node
  else
    luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] = dynamic_node.snip:jump_into(1)
  end
end

return M
