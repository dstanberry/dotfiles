-- low-level utility functions pulled from `williamboman/mason.nvim`

local M = {}

local table_pack = function(...)
  return { n = select("#", ...), ... }
end

---@generic T
---@param fn fun(...): T
---@return fun(...): T
M.partial = function(fn, ...)
  local bound_args = table_pack(...)
  return function(...)
    local args = table_pack(...)
    local merged_args = {}
    for i = 1, bound_args.n do
      merged_args[i] = bound_args[i]
    end
    for i = 1, args.n do
      merged_args[bound_args.n + i] = args[i]
    end
    return fn(unpack(merged_args, 1, bound_args.n + args.n))
  end
end

---@generic T : fun(...)
---@param fn T
---@param arity integer
---@return T
M.curryN = function(fn, arity)
  return function(...)
    local args = table_pack(...)
    if args.n >= arity then
      return fn(unpack(args, 1, arity))
    else
      return M.curryN(M.partial(fn, unpack(args, 1, args.n)), arity - args.n)
    end
  end
end

---@generic T, U
---@type fun(map_fn: (fun(item: T): U), items: T[]): U[]
M.map = M.curryN(vim.tbl_map, 2)

return M
