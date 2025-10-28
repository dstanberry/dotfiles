---@class remote.lualine.component.message
local M = {}

local util = require "remote.lualine.util"
local highlighter = util.highlighter

M.clients = {
  get = function()
    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
    local clients = {}
    local c, ai
    ds.tbl_each(vim.lsp.get_clients { bufnr = buf }, function(client)
      if client and client.name then
        if client.name == "copilot" then
          ai = ds.pad(ds.icons.ai.Normal, "right")
        else
          table.insert(clients, client.name)
        end
      end
    end)
    c = ds.icons.misc.Extensions .. " " .. #clients
    if ai and not ds.plugin.is_installed "sidekick.nvim" then c = (c or "") .. ds.pad(ai, "left", 2) end
    return c
  end,
  color = function() return { fg = ds.color.get "Conceal" } end,
  cond = function() return #vim.lsp.get_clients { bufnr = 0 } > 0 end,
}

M.codecompanion = {
  ctx = {
    get = function()
      local base = ds.icons.ai.Normal
      local buf = _G.codecompanion_current_context
      if not buf then return base end
      local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
      local filename = (filepath):match "^.+/(.+)$"
      return string.format("[ %s %s ]  %s ", ds.icons.documents.SymbolicLink, filename, base)
    end,
    cond = function() return package.loaded.codecompanion and vim.bo.filetype == "codecompanion" end,
  },
  adapter = {
    get = function()
      local buf = vim.api.nvim_get_current_buf()
      local data = _G.codecompanion_chat_metadata and _G.codecompanion_chat_metadata[buf]
      if not data.adapter and data.adapter.name then return "" end
      return string.format(
        "%s (%s) - %d tokens",
        data.adapter.name or "",
        data.adapter.model,
        _G.codecompanion_ds_tokens or 0
      )
    end,
    cond = function() return package.loaded.codecompanion and vim.bo.filetype == "codecompanion" end,
  },
}

M.noice = {
  get = function()
    local text = require("noice").api.status.search.get()
    local query = text:match "%/(.-)%s" or text:match "%?(.-)%s" or ""
    local counter = text:match "%d+%/%d+"
    return string.format("%s %s [%s]", ds.icons.misc.Magnify, query, counter)
  end,
  cond = function()
    return package.loaded.noice and require("noice").api.status.search.has() and util.available_width(80)
  end,
}

M.sidekick = {
  icons = {
    Error = { ds.icons.ai.Error, "DiagnosticError" },
    Warning = { ds.icons.ai.Warning, "DiagnosticWarn" },
    Inactive = { ds.icons.ai.Inactive, "Debug" },
    Normal = { ds.icons.ai.Normal, "Conceal" },
  },
  get = function()
    local status = require("sidekick.status").get()
    return status and ds.pad(vim.tbl_get(M.sidekick.icons, status.kind, 1), "left", 2)
  end,
  color = function()
    if not package.loaded.sidekick then return {} end
    local status = require("sidekick.status").get()
    local hl = status and (status.busy and "DiagnosticWarn" or vim.tbl_get(M.sidekick.icons, status.kind, 2))
    return { fg = ds.color.get(hl or "Comment") }
  end,
  cond = function() return package.loaded.sidekick and require("sidekick.status").get() ~= nil end,
}

M.symbols = {
  _ = {
    has = function() return false end,
    get = function() return "" end,
  },
  get = function()
    local calculate_data = function(symbols)
      symbols = symbols:gsub("%%#StatusLine#", ""):gsub("%%%%", "%%")
      local bc = util.metadata.breadcrumbs.get():gsub("%%#.-#", "")
      local sep = ds.pad(ds.icons.misc.FoldClosed, "right", 2)
      local parts = vim.split(symbols, sep)
      local raw_symbols = symbols:gsub("%%#.-#", ""):gsub("%%*", ""):gsub("*", "")
      local margin = 10
      if util.available_width(#bc + #raw_symbols + margin) then return symbols end
      local raw_parts = vim.split(raw_symbols, sep)
      local trimmed_parts = ds.tbl_reduce(raw_parts, function(acc, part)
        table.insert(acc, part)
        local new_s = table.concat(acc, sep)
        if not util.available_width(#bc + #new_s + margin) then
          if acc[#acc] == part then table.remove(acc, #acc) end
        end
        return acc
      end)
      local result = vim.list_slice(parts, 1, #trimmed_parts)
      if parts[#result + 1] then
        local etc = string.format("%s...", highlighter.sanitize "Winbar")
        table.insert(trimmed_parts, etc)
        if util.available_width(#bc + #table.concat(trimmed_parts, sep) + margin) then
          table.insert(result, etc)
        else
          result[#result] = etc
        end
      end
      return table.concat(result, sep)
    end

    local default = string.format("%s%s", highlighter.sanitize "Winbar", "%=")
    local data = M.symbols._.get()
    return data ~= "%#StatusLine#" and calculate_data(data) or default
  end,
  cond = function()
    local buf = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(buf)
    local function excludes(bufnr, name)
      local ft = vim.bo[bufnr].ft
      return name:match "scratch" or ft:match "dapui_" or ft:match "oil" or vim.tbl_contains(ds.ft.disabled.winbar, ft)
    end
    return vim.api.nvim_buf_is_valid(buf) and not (vim.wo.diff and excludes(buf, fname))
  end,
}

ds.plugin.on_load(
  "trouble.nvim",
  function()
    M.symbols._ = require("trouble").statusline {
      mode = "lsp_document_symbols",
      groups = { "" },
      title = false,
      filter = { range = true },
      format = string.format(
        "%s%s{kind_icon}{symbol.name:NoiceSymbolNormal}",
        highlighter.sanitize "NoiceSymbolSeparator",
        ds.pad(ds.icons.misc.FoldClosed, "right", 2)
      ),
    }
  end
)

return M
