local ls = require "luasnip"

local M = {}

local snip_defs = {
  s = ls.s,
  sn = ls.sn,
  t = ls.t,
  i = ls.i,
  f = function(func, argnodes, ...)
    return ls.f(
      function(args, imm_parent, user_args) return func(args, imm_parent.snippet, user_args) end,
      argnodes,
      ...
    )
  end,
  -- override to enable restore_cursor.
  c = function(pos, nodes, opts)
    opts = opts or {}
    opts.restore_cursor = true
    return ls.c(pos, nodes, opts)
  end,
  d = function(pos, func, argnodes, ...)
    return ls.d(
      pos,
      function(args, imm_parent, old_state, ...) return func(args, imm_parent.snippet, old_state, ...) end,
      argnodes,
      ...
    )
  end,
  isn = require("luasnip.nodes.snippet").ISN,
  l = require("luasnip.extras").lambda,
  dl = require("luasnip.extras").dynamic_lambda,
  rep = require("luasnip.extras").rep,
  r = ls.restore_node,
  p = require("luasnip.extras").partial,
  types = require "luasnip.util.types",
  events = require "luasnip.util.events",
  util = require "luasnip.util.util",
  fmt = require("luasnip.extras.fmt").fmt,
  fmta = require("luasnip.extras.fmt").fmta,
  postfix = require("luasnip.extras.postfix").postfix,
  ts_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix,
  ts_postfix_builtin = require("luasnip.extras.treesitter_postfix").builtin,
  ls = ls,
  ins_generate = function(nodes)
    return setmetatable(nodes or {}, {
      __index = function(table, key)
        local indx = tonumber(key)
        if indx then
          local val = ls.i(indx)
          rawset(table, key, val)
          return val
        end
      end,
    })
  end,
  parse = ls.parser.parse_snippet,
  n = require("luasnip.extras").nonempty,
  m = require("luasnip.extras").match,
  conds = require "luasnip.extras.conditions.expand",
  ai = require "luasnip.nodes.absolute_indexer",
  node_util = require "luasnip.nodes.util",
}

M.setup_snip_env = function() setfenv(2, vim.tbl_extend("force", _G, snip_defs)) end

return M
