---@class util.treesitter
local M = {}

M._cache = {}

local function get_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
  if not parser then return nil end
  local trees = parser:parse()
  if not trees or not trees[1] then return nil end
  return trees[1]:root()
end

local function build_scopes(bufnr)
  local root = get_root(bufnr)
  if not root then return { list = {}, set = {} } end
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local query = lang and vim.treesitter.query.get(lang, "locals") or nil
  if not query then return { list = { root }, set = { [root] = true } } end
  local list, set = {}, {}
  for id, node in query:iter_captures(root, bufnr) do
    local cap = query.captures[id]
    if cap == "local.scope" then
      table.insert(list, node)
      set[node] = true
    end
  end
  -- ensure the root is a scope boundary as a last resort.
  if not set[root] then
    table.insert(list, root)
    set[root] = true
  end
  return { list = list, set = set }
end

local function get_cached_scopes(bufnr)
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local entry = M._cache[bufnr]
  if not entry or entry.tick ~= tick then
    local scopes = build_scopes(bufnr)
    M._cache[bufnr] = { tick = tick, scopes = scopes }
    return scopes
  end
  return entry.scopes
end

---Get all scope nodes for a buffer from cache (building if needed).
---@param bufnr? number
---@return TSNode[] list
function M.get_scopes(bufnr)
  bufnr = vim._resolve_bufnr(bufnr)
  return get_cached_scopes(bufnr).list
end

---Find the nearest containing scope for a node.
---@param node TSNode|nil
---@param bufnr? number
---@param allow_fallback? boolean when true, return the provided node if no scope is found
---@return TSNode|nil scope
function M.containing_scope(node, bufnr, allow_fallback)
  bufnr = vim._resolve_bufnr(bufnr)
  if not node then return end
  local scopes = get_cached_scopes(bufnr)
  local cur = node
  while cur do
    if scopes.set[cur] then return cur end
    cur = cur:parent()
  end
  if allow_fallback then return node end
end

---Iterator over scopes from a starting node up to the root scope.
---@param node TSNode
---@param bufnr? number
---@return fun():TSNode? next
function M.iter_scope_tree(node, bufnr)
  bufnr = vim._resolve_bufnr(bufnr)
  local last_node = node
  return function()
    if not last_node then return end
    local scope = M.containing_scope(last_node, bufnr, false) or get_root(bufnr)
    if not scope then
      last_node = nil
      return
    end
    last_node = scope:parent()
    return scope
  end
end

---Collect scopes from a starting node up to the root scope.
---@param node TSNode
---@param bufnr? number
---@return TSNode[] list
function M.get_scope_tree(node, bufnr)
  local scopes = {}
  for s in M.iter_scope_tree(node, bufnr) do
    table.insert(scopes, s)
  end
  return scopes
end

---Clear cached scopes for a buffer.
---@param bufnr? number
function M.clear_cache(bufnr)
  bufnr = vim._resolve_bufnr(bufnr)
  M._cache[bufnr] = nil
end

return M
