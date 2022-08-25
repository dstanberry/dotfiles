local ts_locals = require "nvim-treesitter.locals"
local ts_utils = require "nvim-treesitter.ts_utils"

local get_node_text = vim.treesitter.get_node_text

local rutil = require "remote.luasnip.util"

---@diagnostic disable: undefined-global
require("remote.luasnip").nodes.setup_snip_env()

local transforms = {
  int = function(_, _)
    return t "0"
  end,
  bool = function(_, _)
    return t "false"
  end,
  string = function(_, _)
    return t [[""]]
  end,
  error = function(_, info)
    if info then
      info.index = info.index + 1

      return c(info.index, {
        t(info.err_name),
        t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
      })
    else
      return t "err"
    end
  end,
  [function(text)
    return string.find(text, "*", 1, true) ~= nil
  end] = function(_, _)
    return t "nil"
  end,
}

local transform = function(text, info)
  local condition_matches = function(condition, ...)
    if type(condition) == "string" then
      return condition == text
    else
      return condition(...)
    end
  end
  for condition, result in pairs(transforms) do
    if condition_matches(condition, text, info) then
      return result(text, info)
    end
  end
  return t(text)
end

local handlers = {
  parameter_list = function(node, info)
    local result = {}
    local count = node:named_child_count()
    for idx = 0, count - 1 do
      local matching_node = node:named_child(idx)
      local type_node = matching_node:field("type")[1]
      table.insert(result, transform(get_node_text(type_node, 0), info))
      if idx ~= count - 1 then
        table.insert(result, t { ", " })
      end
    end
    return result
  end,
  type_identifier = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
}

local function_node_types = {
  function_declaration = true,
  method_declaration = true,
  func_literal = true,
}

local return_types = function(info)
  local cursor_node = ts_utils.get_node_at_cursor()
  local scope = ts_locals.get_scope_tree(cursor_node, 0)
  local function_node
  for _, v in ipairs(scope) do
    if function_node_types[v:type()] then
      function_node = v
      break
    end
  end
  if not function_node then
    print "Not inside of a function"
    return t ""
  end
  local query = vim.treesitter.parse_query(
    "go",
    [[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]]
  )
  for _, node in query:iter_captures(function_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end
end

local make_return_nodes = function(args)
  return snippet_from_nodes(
    nil,
    return_types {
      index = 0,
      err_name = args[1][1],
      func_name = args[2][1],
    }
  )
end

return {
  s(
    { trig = "efi" },
    fmt("{val}, {err1} := {func}({args})\nif {err2} != nil {{\n\treturn {result}\n}}", {
      val = i(1, "val"),
      err1 = i(2, "err"),
      func = i(3, "func"),
      args = i(4),
      err2 = rep(2),
      result = d(5, make_return_nodes, { 2, 3 }),
    })
  ),
  s(
    { trig = "fn" },
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
  s({ trig = "print" }, fmt([[fmt.Println("{}")]], { i(1) })),
}
