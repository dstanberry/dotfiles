local icons = require "ui.icons"
local util = require "util"

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

M.setup = function()
  if not setting_enabled "remote_plugins" then return end
  if M.initialized then return end
  M.initialized = true
  bootstrap()
  lazy_file()
  init()
  M.lazy_notify()
end

return M
