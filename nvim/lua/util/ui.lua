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

---@private
---@alias util.ui.sign.type "mark"|"sign"|"fold"|"git"
---@alias util.ui.sign.spec {name: string, text: string, texthl: string, priority: number, type: util.ui.sign.type}

---@class util.ui.fold.spec
---@field start number Line number where deepest fold starts
---@field level number Fold level, when zero other fields are N/A
---@field llevel number Lowest level that starts in v:lnum
---@field lines number Number of lines from v:lnum to end of closed fold

---@type ffi.namespace*
local C

local sign_opts = {
  left = { "mark", "sign" },
  right = { "fold", "git" },
  folds = {
    open = false,
    git_hl = true,
  },
  git = {
    plugins = { "GitSign" },
  },
  refresh = 50,
}

local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>
local sign_cache = {}
local cache_enabled = false

local function _ffi()
  if not C then
    local ffi = require "ffi"
    ffi.cdef [[
      typedef struct {} Error;
      typedef struct {} win_T;
      typedef struct {
        int start;  // line number where deepest fold starts
        int level;  // fold level, when zero other fields are N/A
        int llevel; // lowest level that starts in v:lnum
        int lines;  // number of lines from v:lnum to end of closed fold
      } foldinfo_T;
      foldinfo_T fold_info(win_T* wp, int lnum);
      win_T *find_window_by_handle(int Window, Error *err);
    ]]
    C = ffi.C
  end
  return C
end
local function cache_signs()
  if cache_enabled then return end
  cache_enabled = true
  local timer = assert(vim.uv.new_timer())
  timer:start(sign_opts.refresh, sign_opts.refresh, function()
    cache = {}
    sign_cache = {}
  end)
end

---@param name string
local function is_git_sign(name)
  for _, pattern in ipairs(sign_opts.git.plugins) do
    if name:find(pattern) then return true end
  end
end

---@param sign? util.ui.sign.spec
local function get_icon(sign)
  if not sign then return "  " end
  local key = (sign.text or "") .. (sign.texthl or "")
  if icon_cache[key] then return icon_cache[key] end
  local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
  text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
  icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  return icon_cache[key]
end

---@param buf number
---@return util.ui.sign.spec[]
local function get_buf_signs(buf)
  local signs = {} ---@type util.ui.sign.spec[]
  -- extmarks
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    local lnum = extmark[2] + 1
    signs[lnum] = signs[lnum] or {}
    table.insert(signs[lnum], {
      name = name,
      type = is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end
  -- marks
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match "[a-zA-Z]" then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "DiagnosticHint", type = "mark" })
    end
  end
  return signs
end

---@param win number
---@param lnum number
local function get_fold_info(win, lnum)
  pcall(_ffi)
  if not C then return end
  local ffi = require "ffi"
  local err = ffi.new "Error"
  local wp = C.find_window_by_handle(win, err)
  if wp == nil then return end
  return C.fold_info(wp, lnum) ---@type util.ui.fold.spec
end

---@param win number
---@param buf number
---@param lnum number
---@return util.ui.sign.spec[]
local function get_signs(win, buf, lnum)
  local buf_signs = sign_cache[buf]
  if not buf_signs then
    buf_signs = get_buf_signs(buf)
    sign_cache[buf] = buf_signs
  end
  local signs = buf_signs[lnum] or {}
  -- folds
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(vim.v.lnum) >= 0 then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif not M.skip_foldexpr[buf] then
      local info = get_fold_info(win, lnum)
      if info and info.level > 0 and info.start == lnum then
        signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
      end
    end
  end)
  table.sort(signs, function(a, b) return (a.priority or 0) > (b.priority or 0) end)
  return signs
end

---Determine what content is shown in the editor gutter and the order, e.g. sign, fold and number
---@return string
function M.statuscolumn()
  local function _get()
    if not cache_enabled then cache_signs() end
    local win = vim.g.statusline_winid
    local lnum = vim.wo[win].number
    local relnum = vim.wo[win].relativenumber
    local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
    local components = { "", "", "" } -- left, middle, right
    if not (show_signs or lnum or relnum) then return "" end

    if (lnum or relnum) and vim.v.virtnum == 0 then
      local num ---@type number
      if relnum and lnum and vim.v.relnum == 0 then
        num = vim.v.lnum
      elseif relnum then
        num = vim.v.relnum
      else
        num = vim.v.lnum
      end
      components[2] = "%=" .. num .. " "
    end

    if show_signs then
      local buf = vim.api.nvim_win_get_buf(win)
      local is_file = vim.bo[buf].buftype == ""
      local signs = get_signs(win, buf, vim.v.lnum)

      if #signs > 0 then
        local signs_by_type = {} ---@type table<util.ui.sign.type,util.ui.sign.spec>
        for _, s in ipairs(signs) do
          signs_by_type[s.type] = signs_by_type[s.type] or s
        end
        local function find(types) ---@param types util.ui.sign.type[]
          for _, t in ipairs(types) do
            if signs_by_type[t] then return signs_by_type[t] end
          end
        end

        local left, right = find(sign_opts.left), find(sign_opts.right)
        if sign_opts.folds.git_hl then
          local git = find { "git" }
          if git and left and left.type == "fold" then left.texthl = git.texthl end
          if git and right and right.type == "fold" then right.texthl = git.texthl end
        end
        components[1] = left and get_icon(left) or "  "
        components[3] = is_file and (right and get_icon(right) or "  ") or ""
      else
        components[1] = "  "
        components[3] = is_file and "  " or ""
      end
    end
    local ret = table.concat(components, "")
    return ("%%@v:lua.require('util.ui').statuscolumn_fold@%s%%T"):format(ret)
  end
  -- use cache if available
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)
  if cache[key] then return cache[key] end
  local ok, ret = pcall(_get)
  if ok then
    cache[key] = ret
    return ret
  end
  return ""
end

function M.statuscolumn_fold()
  local pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then vim.cmd "normal! za" end
  end)
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
