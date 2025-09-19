local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip.nodes").setup_snip_env()

local handlers = {}
local node_types = { function_declaration = true, method_declaration = true, func_literal = true }
local ptr = function(text) return string.find(text, "*", 1, true) ~= nil end
local data_types = {
  ["string"] = function() return t [[""]] end,
  int = function() return t "0" end,
  bool = function() return t "false" end,
  error = function(_, info)
    if info then
      info.index = info.index + 1
      return c(info.index, {
        t(info.err_name),
        t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
      })
    end
    return t "err"
  end,
  [ptr] = function() return t "nil" end,
}

local type2node = function(text, info)
  local same_type = function(dt, ...) return type(dt) == "string" and dt == text or dt(...) end
  for data_type, fn in pairs(data_types) do
    if same_type(data_type, text) then return fn(text, info) end
  end
  return t(text)
end

handlers.parameter_list = function(node, info)
  local result, count = {}, node:named_child_count()
  for idx = 0, count - 1 do
    local matching_node = node:named_child(idx)
    local type_node = matching_node:field("type")[1]
    table.insert(result, type2node(vim.treesitter.get_node_text(type_node, 0), info))
    if idx ~= count - 1 then table.insert(result, t { ", " }) end
  end
  return result
end

handlers.type_identifier = function(node, info)
  local text = vim.treesitter.get_node_text(node, 0)
  return { type2node(text, info) }
end

local first = function(list, predicate)
  for i = 1, #list do
    local v = list[i]
    if predicate(v) then return v end
  end
end

local ret = function(info)
  local cursor_node = vim.treesitter.get_node()
  local scope = ds.treesitter.get_scope_tree(cursor_node, 0)

  local function_node = first(scope, function(n) return node_types[n:type()] end)
  if not function_node then return t "" end
  local query_text = [[
    [
      (method_declaration result: (_) @id)
      (function_declaration result: (_) @id)
      (func_literal result: (_) @id)
    ]
  ]]
  local query = vim.treesitter.query.parse("go", query_text)
  for _, node in query:iter_captures(function_node, 0) do
    if handlers[node:type()] then
      local result = handlers[node:type()](node, info)
      table.insert(result, 1, t " ")
      return result
    end
  end
  return t ""
end

local go_type = function(args) return sn(nil, ret { index = 0, err_name = args[1][1], func_name = args[2][1] }) end

return {
  s(
    { trig = "efi", name = "function call", dscr = "Check error after `|func(..)|` call" },
    fmt("{val}, {err1} := {func}({args})\nif {err2} != nil {{\n\treturn{result}\n}}", {
      val = i(1, "val"),
      err1 = i(2, "err"),
      func = i(3, "func"),
      args = i(4),
      err2 = rep(2),
      result = d(5, go_type, { 2, 3 }),
    })
  ),
  s(
    { trig = "fn", name = "function", dscr = "Declare function" },
    fmt("func {}{}({}) {} {{\n{}\n}}", {
      c(1, {
        t "",
        sn(
          nil,
          fmt("({} {}) ", {
            i(1, "r"),
            i(2, "receiver"),
          })
        ),
      }),
      i(2, "main"),
      i(3, ""),
      c(4, {
        i(1, "error"),
        sn(
          nil,
          fmt("({}, {}) ", {
            i(1, "ret"),
            i(2, "error"),
          })
        ),
      }),
      d(5, rutil.saved_text, {}, { user_args = { { text = "// TODO", indent = true } } }),
    })
  ),
}, {
  s({ trig = "print", name = "log", dscr = "Print to stdout" }, fmt([[fmt.Println("{}")]], { i(1) }), {
    condition = conds.line_begin,
  }),
}
