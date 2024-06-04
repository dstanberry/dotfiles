if not setting_enabled "remote_plugins" then return end

local icons = require "ui.icons"
local util = require "util"

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

local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

local function lazy_file()
  local Event = require "lazy.core.handler.event"
  Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile

  local events = {} ---@type {event: string, pattern?: string, buf: number, data?: any}[]

  local function load()
    if #events == 0 then return end
    vim.api.nvim_del_augroup_by_name "lazy_file"

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      Event.trigger {
        event = event.event,
        exclude = skips[event.event],
        data = event.data,
        buf = event.buf,
      }
      if vim.tbl_contains(vim.api.nvim_list_bufs(), event.buf) and vim.bo[event.buf].filetype then
        Event.trigger {
          event = "FileType",
          buf = event.buf,
        }
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

lazy_file()

require("lazy").setup("remote", {
  root = vim.fs.joinpath(vim.fn.stdpath "data", "lazy"),
  lockfile = vim.fs.joinpath(vim.fn.stdpath "config", "lua", "remote", "lazy-lock.json"),
  ui = {
    border = util.map(icons.border.ThinBlock, function(v) return { v, "FloatBorder" } end),
    backdrop = 95,
    custom_keys = {
      ["<localleader>d"] = function(plugin) dump(plugin) end,
      ["<localleader>t"] = function(plugin)
        local cmd = has "win32" and "pwsh"
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
