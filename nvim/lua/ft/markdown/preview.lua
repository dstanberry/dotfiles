---@class ft.markdown.preview
---@overload fun()
local M = setmetatable({}, {
  __call = function(m, ...) return m.launch(...) end,
})

---@type table<string, number>
local jids = {}

---@param buf? number
M.stop = function(buf)
  local stopped = false
  buf = buf or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then
    for _, id in pairs(jids) do
      if vim.fn.jobstop(id) == 1 then stopped = true end
    end
    jids = {}
  end
  local proc = not stopped and vim.api.nvim_buf_get_name(buf)
  if proc and jids[proc] then
    if vim.fn.jobstop(jids[proc]) == 1 then stopped = true end
    jids[proc] = nil
  end
  if stopped then
    ds.warn "Stopped markdown preview"
    return true
  end
end

---@param cmd string[]
local start = function(cmd)
  local jid = vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if not vim.tbl_contains({ 0, 143 }, code) then
        ds.error(("Command `%s` exited with code `%d`"):format(table.concat(cmd, " "), code))
      end
    end,
  })
  if jid > 0 then
    jids[cmd[#cmd]] = jid
    return true
  end
  ds.error(("Failed to start command: `%s`"):format(table.concat(cmd, " ")))
end

---@param buf? number
M.launch = function(buf)
  if M.stop() then return end
  buf = buf or vim.api.nvim_get_current_buf()
  local url = "http://localhost:3333"
  local cmd = { "gh", "markdown-preview", "--disable-auto-open" }
  local browser = (ds.has "win32" or ds.has "wsl") and { "cmd.exe", "/c", "start", url } or { "open", url }
  if vim.bo[buf].filetype == "markdown" then table.insert(cmd, vim.api.nvim_buf_get_name(buf)) end
  if start(cmd) and start(browser) then ds.info "Started markdown preview" end
end

return M
