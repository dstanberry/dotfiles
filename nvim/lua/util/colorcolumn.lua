---@class util.colorcolumn
local M = setmetatable({}, {
  __call = function(m, ...) return m.draw(...) end,
})

---@private
M.initialized = false

---@alias util.colorcolumn.config.exclude {filetypes?:string[], buftypes?:string[]}
---@alias util.colorcolumn.config { enabled?:boolean, char?:string|string[], highlight?:string|string[], virtcolumn?:string, exclude?:util.colorcolumn.config.exclude }

local ns_id ---@type integer|nil
local default_opts = { ---@type util.colorcolumn.config
  enabled = true,
  char = ds.icons.misc.VerticalBarRight,
  highlight = "ColorColumn",
  virtcolumn = "",
  exclude = {
    buftypes = { "nofile", "quickfix", "terminal", "prompt" },
    filetypes = vim.tbl_extend("keep", ds.ft.disabled.statusline, ds.ft.disabled.winbar),
  },
}

--- Number of monospace characters at which the editor ruler will render
---@return number[]
local function rulers(win, buf)
  local cc = vim.api.nvim_get_option_value("colorcolumn", { win = win })
  local cc_list = cc ~= "" and vim.split(cc, ",") or {}
  local vc_list = default_opts.virtcolumn ~= "" and vim.split(default_opts.virtcolumn, ",") or {}
  local all = {}

  for _, c in ipairs(vim.list_extend(cc_list, vc_list)) do
    if c ~= "" then table.insert(all, c) end
  end

  if #all == 0 then return {} end

  local textwidth = vim.api.nvim_get_option_value("textwidth", { buf = buf })
  local out = {}

  for _, c in ipairs(all) do
    if vim.startswith(c, "+") then
      if textwidth ~= 0 then table.insert(out, textwidth + tonumber(c:sub(2))) end
    elseif vim.startswith(c, "-") then
      if textwidth ~= 0 then table.insert(out, textwidth - tonumber(c:sub(2))) end
    elseif tonumber(c) then
      table.insert(out, tonumber(c))
    end
  end

  table.sort(out, function(a, b) return a > b end)

  return out
end

local function provider(_, win, buf, topline, botline_guess)
  if not default_opts.enabled then return false end

  local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
  local columns = rulers(win, buf)

  if not vim.api.nvim_buf_is_valid(buf) or vim.tbl_contains(default_opts.exclude.buftypes, bt) then return false end
  if ft == "" or vim.tbl_contains(default_opts.exclude.filetypes, ft) then return false end
  if #columns == 0 then
    pcall(vim.api.nvim_buf_clear_namespace, buf, ns_id, topline, botline_guess)
    return false
  end

  pcall(vim.api.nvim_buf_clear_namespace, buf, ns_id, topline, botline_guess)

  local char = default_opts.char ---@type string
  local hl = default_opts.highlight ---@type string
  local leftcol = vim.api.nvim_win_call(win, vim.fn.winsaveview).leftcol or 0

  char = type(hl) == "string" and { char } or char
  hl = type(hl) == "string" and { hl } or hl

  local i = topline
  while i <= botline_guess do
    for j, col in ipairs(columns) do
      local width = vim.api.nvim_win_call(win, function() return vim.fn.virtcol { i, "$" } - 1 end)

      if width < col then
        local idx = #columns - j + 1
        pcall(vim.api.nvim_buf_set_extmark, buf, ns_id, i - 1, 0, {
          virt_text = { { char[((idx - 1) % #char) + 1], hl[((idx - 1) % #hl) + 1] } },
          virt_text_pos = "overlay",
          hl_mode = "combine",
          virt_text_win_col = col - 1 - leftcol,
          priority = 1,
        })
      end
    end

    local fold_end = vim.api.nvim_win_call(win, function() return vim.fn.foldclosedend(i) end)

    if fold_end ~= -1 then i = fold_end end
    i = i + 1
  end

  return false
end

local function reset_hl()
  local hl = default_opts.highlight
  local defaults = { link = default_opts.highlight or "NonText" }

  if vim.tbl_contains({ "ColorColumn", "VirtColumn" }, hl) then
    local fg, bg = ds.color.get "ColorColumn", ds.color.get("ColorColumn", true)
    defaults = (bg and not fg) and { fg = bg } or { fg = fg }
    default_opts.highlight = "VirtColumn"
  end

  vim.api.nvim_set_hl(0, "TreesitterContextSeparator", defaults)
  vim.api.nvim_set_hl(0, "VirtColumn", vim.tbl_deep_extend("keep", { default = true }, defaults))
  vim.api.nvim_set_hl(0, "ColorColumn", {})
end

---Configures the virtual column rendering using custom extmarks and a decoration provider.
---@param opts util.colorcolumn.config?
function M.draw(opts)
  default_opts = vim.tbl_deep_extend("force", {}, default_opts, opts or {})

  if default_opts.char ~= nil then
    local ok = false

    if type(default_opts.char) == "string" then ok = vim.fn.strdisplaywidth(default_opts.char) <= 1 end
    if type(default_opts.char) == "table" and #default_opts.char > 0 then
      ok = true
      for i = 1, #default_opts.char do
        if type(default_opts.char[i]) ~= "string" or vim.fn.strdisplaywidth(default_opts.char[i]) > 1 then
          ok = false
          break
        end
      end
    end
    if not ok then return end
  end

  if not M.initialized then
    reset_hl()
    ns_id = vim.api.nvim_create_namespace "ds_virtual_colorcolumn"
    vim.api.nvim_set_decoration_provider(ns_id, { on_win = provider })
    vim.api.nvim_create_autocmd("ColorScheme", { group = ds.augroup "util.colorcolumn", callback = reset_hl })
    M.initialized = true
  end

  if not default_opts.enabled then
    pcall(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_clear_namespace(b, ns_id, 0, -1)
      end
    end)
  end
end

return M
