local M = {}

M.init_notify = function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.print = function(...) Snacks.debug.inspect(...) end

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
