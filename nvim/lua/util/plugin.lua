---@class util.plugin
local M = {}

local group = ds.augroup "lazy"

---Deeply merges multiple tables.
---If `lazy.nvim` is available, it uses its merge function.
---Otherwise, it falls back to `vim.tbl_deep_extend` with **force** enabled.
---@param ... any Tables to merge.
---@return table The merged table.
function M.deep_merge(...)
  local ok, Util = pcall(require, "lazy.core.util")
  if not ok then return vim.tbl_deep_extend("force", ...) end
  return Util.merge(...)
end

---@class util.plugin.pkg_path_spec
---@field exe? boolean If true, returns the path to the executable in the `bin` directory,
---@field path? string Optional subpath to append to the package directory.
---@field warn? boolean If true (default), warns if the path does not exist.

---Gets the path of a package managed by `mason.nvim`.
---@param pkg string The package name.
---@param opts? util.plugin.pkg_path_spec Options for the function.
---@return string The full path to the package or subpath.
function M.get_pkg_path(pkg, opts)
  local root = vim.fs.joinpath(vim.fn.stdpath "data", "mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  local ret = vim.fs.joinpath(root, (opts.exe and "bin" or "packages"), pkg, opts.path)
  if opts.warn and not vim.uv.fs_stat(ret) then
    vim.notify(
      ("Package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, opts.path),
      vim.log.levels.WARN,
      { title = "Mason" }
    )
  end
  return ret
end

---Retrieves the options for a specific plugin.
---@param name string The name of the plugin.
---@return table The options for the plugin, or an empty table if not found.
function M.get_opts(name)
  local Plugin = {}
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return Plugin end
  local plugin = Config.spec.plugins[name]
  if not plugin then return {} end
  ok, Plugin = pcall(require, "lazy.core.plugin")
  if not ok then return {} end
  return Plugin.values(plugin, "opts", false)
end

---Checks if a plugin is installed.
---@param plugin string The name of the plugin.
---@return boolean True if the plugin is installed, false otherwise.
function M.is_installed(plugin)
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return false end
  return Config.spec.plugins[plugin] ~= nil
end

---Checks if a plugin is loaded.
---@param name string The name of the plugin.
---@return boolean|{[string]:string}|{time:number}
function M.is_loaded(name)
  local ok, Config = pcall(require, "lazy.core.config")
  if not ok then return false end
  return Config.plugins[name] and Config.plugins[name]._.loaded or false
end

---Executes a function when a plugin is loaded.
---If the plugin is already loaded, the function is executed immediately.
---Otherwise, it sets up an autocommand to execute the function when the plugin is loaded.
---@param name string The name of the plugin.
---@param fn fun(name:string) The function to execute.
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      group = group,
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

---**Safely** deletes a keymap if it is already defined and not managed by `lazy.nvim`
---@param mode string | string[] The mode(s) for the keymap.
---@param lhs string The left-hand side of the keymap.
function M.keymap_del(mode, lhs)
  local modes = type(mode) == "string" and { mode } or mode
  local ok, Handler = pcall(require, "lazy.core.handler")
  if not ok then
    for _, m in ipairs(modes) do
      if vim.fn.maparg(lhs, m) ~= "" then pcall(vim.keymap.del, m, lhs) end
    end
    return
  end
  local keys = Handler.handlers.keys ---@cast keys LazyKeysHandler
  modes = vim.tbl_filter(function(m) ---@param m string
    return not (keys.have and keys:have(lhs, m))
  end, modes)
  for _, m in ipairs(modes) do
    if vim.fn.maparg(lhs, m) ~= "" then pcall(vim.keymap.del, m, lhs) end
  end
end

---**Safely** sets a keymap without clobbering any existing mappings
---@param mode string | string[] The mode(s) for the keymap.
---@param lhs string The left-hand side of the keymap.
---@param rhs string|function The right-hand side of the keymap.
---@param opts? vim.keymap.set.Opts Optional keymap options.
function M.keymap_set(mode, lhs, rhs, opts)
  local modes = type(mode) == "string" and { mode } or mode
  local ok, Handler = pcall(require, "lazy.core.handler")
  if not ok then
    if vim.fn.maparg(lhs) == "" then
      vim.keymap.set(modes, lhs, rhs, opts)
      return
    end
  end
  local keys = Handler.handlers.keys ---@cast keys LazyKeysHandler
  modes = vim.tbl_filter(function(m) ---@param m string
    return not (keys.have and keys:have(lhs, m))
  end, modes)
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then opts.remap = nil end
    if vim.fn.maparg(lhs) == "" then vim.keymap.set(modes, lhs, rhs, opts) end
  end
end

---Executes a function with error handling.
---If an error occurs, it uses the provided options to handle it.
---@generic R
---@param fn fun():R? The function to execute.
---@param opts? string|{msg:string, on_error:fun(msg)} Options for error handling.
---@return R The result of the function, or nil if an error occurred.
function M.try_catch(fn, opts)
  local ok, Util = pcall(require, "lazy.core.util")
  if not ok then return opts end
  return Util.try(fn, opts)
end

local delay_notifications = function()
  local notifications = {}
  local orig = vim.notify

  local function temp(...) table.insert(notifications, vim.F.pack_len(...)) end

  vim.notify = temp
  local timer = assert(vim.uv.new_timer()) ---@type uv_timer_t
  local check = assert(vim.uv.new_check())

  local function replay()
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

---Sets up the remote plugin ecosystem
---Initializes `lazy.nvim`` and configures its settings.
---@param opts? table Optional setup options.
function M.setup(opts)
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
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "VeryLazy",
      once = true,
      callback = opts.on_init,
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "lazy",
    callback = vim.schedule_wrap(function()
      vim.opt_local.cursorline = false
      vim.opt_local.listchars = vim.tbl_deep_extend("force", vim.opt_local.listchars:get(), { lead = " ", tab = "  " })
    end),
  })

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
