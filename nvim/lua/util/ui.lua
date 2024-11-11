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
---@alias util.ui.sign.spec {name:string, text:string, texthl:string, priority:number, type: util.ui.sign.type}

local sign_opts = {
  left = { "mark", "sign" },
  right = { "fold", "git" },
  folds = {
    open = false,
    git_hl = true,
  },
  git = {
    plugins = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50,
}

---@type table<number,table<number,util.ui.sign.spec[]>>
local cache = {}
local cache_enabled = false

local cache_signs = function()
  if cache_enabled then return end
  cache_enabled = true
  local timer = assert(vim.uv.new_timer())
  timer:start(sign_opts.refresh, sign_opts.refresh, function() cache = {} end)
end

---@param name string
local is_git_sign = function(name)
  for _, pattern in ipairs(sign_opts.git.plugins) do
    if name:find(pattern) then return true end
  end
end

---@param sign? util.ui.sign.spec
---@param len? number
local get_icon = function(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

---@param buf number
---@return util.ui.sign.spec[]
local get_buf_signs = function(buf)
  if cache[buf] then return cache[buf] end
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
  -- update cache
  cache[buf] = signs
  return signs
end

---@param win number
---@param buf number
---@param lnum number
---@return util.ui.sign.spec[]
local get_signs = function(win, buf, lnum)
  local signs = get_buf_signs(buf)[lnum] or {}
  -- fold signs
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(vim.v.lnum) >= 0 then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif not M.skip_foldexpr[buf] and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">" then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)
  table.sort(signs, function(a, b) return (a.priority or 0) > (b.priority or 0) end)
  return signs
end

---Determine what content is shown in the editor gutter and the order, e.g. sign, fold and number
---@return string
function M.statuscolumn()
  cache_signs()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"
  local components = { "", "", "" } -- left, middle, right
  if show_signs then
    local signs = get_signs(win, buf, vim.v.lnum)
    ---@param types util.ui.sign.type[]
    local function find(types)
      for _, t in ipairs(types) do
        for _, s in ipairs(signs) do
          if s.type == t then return s end
        end
      end
    end
    local left = find(sign_opts.left)
    local right = find(sign_opts.right)
    if sign_opts.folds.git_hl then
      local git = find { "git" }
      if git and left and left.type == "fold" then left.texthl = git.texthl end
      if git and right and right.type == "fold" then right.texthl = git.texthl end
    end
    components[1] = get_icon(left)
    components[3] = is_file and get_icon(right) or ""
  end
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then components[2] = "%=%l " end
  if vim.v.virtnum ~= 0 then components[2] = "%= " end
  return table.concat(components, "")
end

return M
