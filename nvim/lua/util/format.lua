---@class util.format
---@overload fun(opts?: {force?:boolean})
local M = setmetatable({}, {
  __call = function(m, ...) return m.format(...) end,
})

---@class util.format.formatter
---@field name string
---@field modname? string
---@field primary? boolean
---@field format fun(bufnr:number)
---@field sources fun(bufnr:number):string[]
---@field priority number

M.default_formatter = {} ---@type {name?: string, modname?: string}
M.formatters = {} ---@type util.format.formatter[]

---@param enable? boolean
---@param buf? boolean
M.enable = function(enable, buf)
  if enable == nil then enable = true end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
  M.list(buf)
end

---@param buf? number
M.enabled = function(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat
  if baf ~= nil then return baf end
  return gaf == nil or gaf
end

---@param opts? {force?:boolean, buf?:number}
M.format = function(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or M.enabled(buf)) then return end
  local done = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if formatter.active then
      done = true
      ds.plugin.try_catch(
        function() return formatter.format(buf) end,
        { msg = "Formatter `" .. formatter.name .. "` failed" }
      )
    end
  end
  if not done and opts and opts.force then ds.warn("No formatter available", { title = "LSP: Formatting" }) end
end

M.formatexpr = function()
  if M.default_formatter.name and M.default_formatter.modname then
    if ds.plugin.is_installed(M.default_formatter.name) then
      local ok, _mod = pcall(require, M.default_formatter.modname)
      if ok and _mod.formatexpr then return _mod.formatexpr() end
    end
  end
  return vim.lsp.formatexpr { timeout_ms = 3000 }
end

---@param buf? number
M.list = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = M.enabled(buf)
  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
  }
  local have = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
      end
    end
  end
  if not have then lines[#lines + 1] = "\n***No formatters available for this buffer.***" end
  ds[enabled and "info" or "warn"](
    table.concat(lines, "\n"),
    { title = "LSP: Formatting (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

---@param formatter util.format.formatter
M.register = function(formatter)
  M.default_formatter = formatter.primary and {
    module = formatter.name,
    modname = formatter.modname,
  } or M.default_formatter
  M.formatters[#M.formatters + 1] = formatter
  table.sort(M.formatters, function(a, b) return a.priority > b.priority end)
end

---@param buf? number
---@return (util.format.formatter | {active:boolean,resolved:string[]})[]
M.resolve = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local have_primary = false
  return vim.tbl_map(function(formatter) ---@param formatter util.format.formatter
    local sources = formatter.sources(buf)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false
    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, M.formatters)
end

---@param buf? boolean
M.toggle = function(buf)
  local name = M.default_formatter.modname or "lsp"
  return Snacks.toggle {
    name = "auto format (" .. (buf and "buffer" or "global") .. ")",
    wk_desc = { enabled = name .. ": disable ", disabled = name .. ": enable " },
    get = function()
      if not buf then return vim.g.autoformat == nil or vim.g.autoformat end
      return ds.format.enabled()
    end,
    set = function(state) ds.format.enable(state, buf) end,
  }
end

return M
