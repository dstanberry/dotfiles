---@class remote.lualine.component.lsp
local M = {}

local util = require "remote.lualine.util"
local highlighter = util.highlighter

M.ai = {
  get = function()
    local status = require("sidekick.status").get()
    return status and ds.pad(vim.tbl_get(ds.icons.ai, status.kind), "left", 2)
  end,
  cond = function() return require("sidekick.status").get() ~= nil end,
}

M.clients = {
  get = function()
    local winid = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(winid)
    local clients = {}
    local c, ai
    ds.foreach(vim.lsp.get_clients { bufnr = buf }, function(client)
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
  cond = function() return #vim.lsp.get_clients { bufnr = 0 } > 0 end,
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
    return not (
      fname:match "%[Scratch%]"
      or vim.bo[buf].ft:match "dapui_"
      or vim.bo[buf].ft:match "oil"
      or vim.tbl_contains(ds.ft.empty.winbar, vim.bo[buf].ft)
      or vim.tbl_contains(ds.ft.disabled.winbar, vim.bo[buf].ft)
    )
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
