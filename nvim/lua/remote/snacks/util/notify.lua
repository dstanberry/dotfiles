---@class remote.snacks.util.notify
local M = {}

M.setup = function()
  ds.inspect = function(...) Snacks.debug.inspect(...) end
  ds.trace = function() Snacks.debug.backtrace() end
  ds.info = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Info"
    Snacks.notify.info(msg, opts)
    -- vim.notify(msg, vim.log.levels.INFO, opts)
  end
  ds.warn = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Warning"
    Snacks.notify.warn(msg, opts)
    -- vim.notify(msg, vim.log.levels.WARN, opts)
  end
  ds.error = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Error"
    Snacks.notify.error(msg, opts)
    -- vim.notify(msg, vim.log.levels.ERROR, opts)
  end
end

return M
