---@class util.plugin
local M = {}

---@param ... any
M.deep_merge = function(...)
  local ok, Util = pcall(require, "lazy.core.util")
  if not ok then return vim.tbl_deep_extend("force", ...) end
  return Util.merge(...)
end

---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
M.get_pkg_path = function(pkg, path, opts)
  local root = vim.fs.joinpath(vim.fn.stdpath "data", "mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = vim.fs.joinpath(root, "packages", pkg, path)
  if opts.warn and not vim.loop.fs_stat(ret) then
    vim.notify(
      ("Package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path),
      vim.log.levels.WARN,
      { title = "Mason" }
    )
  end
  return ret
end

---@param name string
M.get_opts = function(name)
  local Plugin = {}
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return Plugin end
  local plugin = Config.spec.plugins[name]
  if not plugin then return {} end
  ok, Plugin = pcall(require, "lazy.core.plugin")
  if not ok then return {} end
  return Plugin.values(plugin, "opts", false)
end

---@param plugin string
M.is_installed = function(plugin)
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return false end
  return Config.spec.plugins[plugin] ~= nil
end

---@param name string
M.is_loaded = function(name)
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return false end
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
M.on_load = function(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(args)
        if args.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

---@generic R
---@param fn fun():R?
---@param opts? string|{msg:string, on_error:fun(msg)}
---@return R
M.try_catch = function(fn, opts)
  local ok, Util = pcall(require, "lazy.core.util")
  if not ok then return opts end
  return Util.try(fn, opts)
end

local delay_notifications = function()
  local notifications = {}
  local function temp(...) table.insert(notifications, vim.F.pack_len(...)) end

  local orig = vim.notify
  vim.notify = temp
  local timer = vim.uv.new_timer()
  local check = assert(vim.uv.new_check())
  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      for _, notice in ipairs(notifications) do
        vim.notify(vim.F.unpack_len(notice))
      end
    end)
  end
  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then replay() end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

---@private
M.initialized = false

M.setup = function(opts)
  if not ds.setting_enabled "remote_plugins" or M.initialized then return end
  M.initialized = true
  opts = opts or {}

  delay_notifications()

  local lazypath = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "lazy.nvim")
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  local Event = require "lazy.core.handler.event"
  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile

  if opts.on_init and type(opts.on_init) == "function" then
    vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = opts.on_init })
  end

  require("lazy").setup {
    spec = {
      { import = "remote" },
    },
    defaults = { lazy = true },
    root = vim.fs.joinpath(vim.fn.stdpath "data", "lazy"),
    lockfile = vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "lazy-lock.json"),
    ui = {
      border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
      backdrop = 95,
      custom_keys = {
        ["<localleader>d"] = function(plugin) print(plugin) end,
        ["<localleader>t"] = function(plugin)
          local cmd = ds.has "win32" and "pwsh"
          require("lazy.util").float_term(cmd, {
            cwd = plugin.dir,
          })
        end,
      },
    },
    diff = { cmd = "terminal_git" },
    performance = {
      cache = { enabled = true },
      rtp = {
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }
end

return M
