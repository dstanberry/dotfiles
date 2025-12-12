---@class util.ui
local M = {}

---@private
---@type table<number,boolean>
M.skip_foldexpr = {}

local skip_check = assert(vim.uv.new_check())

---Defines the conditions that determine how the text at the current cursor position might be folded
---@return integer|string fold-level
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.b[buf].ts_highlight then return "0" end
  if M.skip_foldexpr[buf] then return "0" end
  if vim.bo[buf].buftype ~= "" then return "0" end
  if vim.bo[buf].filetype == "" then return "0" end
  local ok = pcall(vim.treesitter.get_parser, buf)
  if ok then return vim.treesitter.foldexpr() end
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

---@alias util.ui.virtcolumn.config.exclude {filetypes?:string[], buftypes?:string[]}
---@alias util.ui.virtcolumn.config { enabled?:boolean, char?:string|string[], highlight?:string|string[], virtcolumn?:string, exclude?:util.ui.virtcolumn.config.exclude }

---@type util.ui.virtcolumn.config
local virtcol_opts = {
  enabled = true,
  char = ds.icons.misc.VerticalBarRight,
  highlight = "ColorColumn",
  virtcolumn = "",
  exclude = {
    buftypes = { "nofile", "quickfix", "terminal", "prompt" },
    filetypes = vim.tbl_extend("keep", ds.ft.disabled.statusline, ds.ft.disabled.winbar),
  },
}

local virtcol_ns ---@type integer|nil
local virtcol_initialized = false

local function virtcol_columns(win, buf)
  local cc = vim.api.nvim_get_option_value("colorcolumn", { win = win })
  local cc_list = cc ~= "" and vim.split(cc, ",") or {}
  local vc_list = virtcol_opts.virtcolumn ~= "" and vim.split(virtcol_opts.virtcolumn, ",") or {}
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

local function virtcol_provider(_, win, buf, topline, botline_guess)
  if not virtcol_opts.enabled then return false end
  local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
  if not vim.api.nvim_buf_is_valid(buf) or vim.tbl_contains(virtcol_opts.exclude.buftypes, bt) then return false end
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
  if ft == "" or vim.tbl_contains(virtcol_opts.exclude.filetypes, ft) then return false end
  local columns = virtcol_columns(win, buf)
  if #columns == 0 then
    pcall(vim.api.nvim_buf_clear_namespace, buf, virtcol_ns, topline, botline_guess)
    return false
  end
  pcall(vim.api.nvim_buf_clear_namespace, buf, virtcol_ns, topline, botline_guess)
  local char = virtcol_opts.char ---@type string
  local hl = virtcol_opts.highlight ---@type string
  char = type(hl) == "string" and { char } or char
  hl = type(hl) == "string" and { hl } or hl
  local leftcol = vim.api.nvim_win_call(win, vim.fn.winsaveview).leftcol or 0
  local i = topline
  while i <= botline_guess do
    for j, col in ipairs(columns) do
      local width = vim.api.nvim_win_call(win, function() return vim.fn.virtcol { i, "$" } - 1 end)
      if width < col then
        local idx = #columns - j + 1
        pcall(vim.api.nvim_buf_set_extmark, buf, virtcol_ns, i - 1, 0, {
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

---Configures the virtual column rendering using custom extmarks and a decoration provider.
---@param opts util.ui.virtcolumn.config?
function M.virtcolumn(opts)
  virtcol_opts = vim.tbl_deep_extend("force", {}, virtcol_opts, opts or {})

  if virtcol_opts.char ~= nil then
    local ok = false
    if type(virtcol_opts.char) == "string" then ok = vim.fn.strdisplaywidth(virtcol_opts.char) <= 1 end
    if type(virtcol_opts.char) == "table" and #virtcol_opts.char > 0 then
      ok = true
      for i = 1, #virtcol_opts.char do
        if type(virtcol_opts.char[i]) ~= "string" or vim.fn.strdisplaywidth(virtcol_opts.char[i]) > 1 then
          ok = false
          break
        end
      end
    end
    if not ok then return end
  end

  if not virtcol_initialized then
    local function reset_hl()
      local hl = virtcol_opts.highlight
      local defaults = { link = virtcol_opts.highlight or "NonText" }
      if vim.tbl_contains({ "ColorColumn", "VirtColumn" }, hl) then
        local fg, bg = ds.color.get "ColorColumn", ds.color.get("ColorColumn", true)
        defaults = (bg and not fg) and { fg = bg } or { fg = fg }
        virtcol_opts.highlight = "VirtColumn"
      end
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", defaults)
      vim.api.nvim_set_hl(0, "VirtColumn", vim.tbl_deep_extend("keep", { default = true }, defaults))
      vim.api.nvim_set_hl(0, "ColorColumn", {})
    end

    reset_hl()
    virtcol_ns = vim.api.nvim_create_namespace "ds_virtual_colorcolumn"
    vim.api.nvim_set_decoration_provider(virtcol_ns, { on_win = virtcol_provider })
    vim.api.nvim_create_autocmd("ColorScheme", { group = ds.augroup "util.ui.virtcol", callback = reset_hl })
    virtcol_initialized = true
  end

  if not virtcol_opts.enabled then
    pcall(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        vim.api.nvim_buf_clear_namespace(b, virtcol_ns, 0, -1)
      end
    end)
  end
end

return M
