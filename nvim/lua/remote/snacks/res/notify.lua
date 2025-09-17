---@class remote.snacks.res.notify
local M = {}

M.setup = function()
  ds.log = function(...) Snacks.debug.inspect(...) end
  ds.bt = function() Snacks.debug.backtrace() end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim._print = function(_, ...) ds.log(...) end

  ds.info = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Info"
    Snacks.notify.info(msg, opts)
  end

  ds.warn = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Warning"
    Snacks.notify.warn(msg, opts)
  end

  ds.error = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Error"
    Snacks.notify.error(msg, opts)
  end
end

return M
