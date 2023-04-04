local M = {}

---Prints the location and line number of the current stack level
function M.get_location()
  local me = debug.getinfo(1, "S")
  local level = 2
  local info = debug.getinfo(level, "S")
  while info and info.source == me.source do
    level = level + 1
    info = debug.getinfo(level, "S")
  end
  info = info or me
  local source = info.source:sub(2)
  source = vim.loop.fs_realpath(source) or source
  return ("%s:%s"):format(source, info.linedefined)
end

---Displays a notification containing a human-readable representation of the object provided
---@param value any
---@param opts? { location:string }
function M.dump(value, opts)
  opts = opts or {}
  opts.location = opts.location or M.get_location()
  if vim.in_fast_event() then return vim.schedule(function() M.dump(value, opts) end) end
  opts.location = vim.fn.fnamemodify(opts.location, ":~:.")
  local msg = vim.inspect(value)
  local title = vim.F.if_nil(opts.title, "Debug")
  vim.notify(msg, vim.log.levels.INFO, {
    title = title,
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, "lua") then vim.bo[buf].filetype = "lua" end
    end,
  })
end

return M
