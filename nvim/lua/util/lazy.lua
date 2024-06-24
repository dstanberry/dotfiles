---@class util.lazy
local M = {}

local bootstrap = function()
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
end

local init = function()
  require("lazy").setup("remote", {
    defaults = { lazy = true },
    root = vim.fs.joinpath(vim.fn.stdpath "data", "lazy"),
    lockfile = vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "lazy-lock.json"),
    ui = {
      border = ds.map(vim.g.ds_icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
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
    install = { missing = true },
    diff = { cmd = "terminal_git" },
    performance = {
      cache = { enabled = true },
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
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
  })
end

local lazy_file = function()
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
      -- skip if we already entered vim
      if vim.v.vim_did_enter == 1 then return end
      -- try to guess the filetype (may change later on during neovim startup)
      local ft = vim.filetype.match { buf = event.buf }
      if ft then
        -- add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then vim.bo[event.buf].syntax = ft end
        vim.cmd [[redraw]]
      end
    end,
  })

  local Event = require "lazy.core.handler.event"
  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

M.initialized = false

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

M.lazy_notify = function()
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

---@param name string
---@param fn fun(name:string)
M.on_load = function(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

M.setup = function()
  if not ds.setting_enabled "remote_plugins" then return end
  if M.initialized then return end
  M.initialized = true
  bootstrap()
  lazy_file()
  init()
  M.lazy_notify()
  local browse = function()
    local lines = require("lazy.manage.process").exec { "git", "remote", "-v" }
    local remotes = {}
    for _, line in ipairs(lines) do
      local name, url = line:match "(%S+)%s+(%S+)%s+%(fetch%)"
      if name and url then
        if
          (
            vim.g.config_github_enterprise_hostname
            and url:find(("git@%s"):format(vim.g.config_github_enterprise_hostname))
          )
          or url:find "git@github.com"
          or url:find "git@bitbucket.org"
          or url:find "git@gitlab.com"
        then
          url = url:gsub("git@(%S+):", "https://%1/"):gsub(".git$", "")
        end
        table.insert(remotes, { name = name, url = url })
      end
    end
    local open = function(remote)
      if remote then
        print(("Opening [%s](%s)"):format(remote.name, remote.url))
        vim.ui.open(remote.url)
      end
    end
    if #remotes == 0 then
      return print "No git remotes found"
    elseif #remotes == 1 then
      return open(remotes[1])
    end
    vim.ui.select(remotes, {
      prompt = "Select remote to browse",
      format_item = function(item) return item.name .. (" "):rep(8 - #item.name) .. " 🔗 " .. item.url end,
    }, open)
  end
  vim.keymap.set("n", "<localleader>gb", browse, { noremap = true, silent = true, desc = "git: browse remote" })
end

return M
