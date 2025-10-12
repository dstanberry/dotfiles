---@class remote.snacks.stash.util
local M = {}

M.setup = function()
  ds.log = function(...) Snacks.debug.inspect(...) end
  ds.bt = function() Snacks.debug.backtrace() end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim._print = function(_, ...) ds.log(...) end

  ---@param msg string|string[]
  ---@param opts? snacks.notify.Opts
  ds.info = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Info"
    Snacks.notify.info(msg, opts)
  end

  ---@param msg string|string[]
  ---@param opts? snacks.notify.Opts
  ds.warn = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Warning"
    Snacks.notify.warn(msg, opts)
  end

  ---@param msg string|string[]
  ---@param opts? snacks.notify.Opts
  ds.error = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "Error"
    Snacks.notify.error(msg, opts)
  end

  ---@param key string
  ---@param opts util.keymap_toggle.opts
  ds.toggle_keymap = function(key, opts)
    Snacks.toggle({
      notify = false,
      wk_desc = { enabled = opts.enabled, disabled = opts.disabled },
      name = opts.desc,
      get = opts.get,
      set = opts.set,
    }):map(key)
  end
end

return M
