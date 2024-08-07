---@class util.ui
local M = {}

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

---Defines the conditions that determine how the text at the current cursor position might be folded
---@return integer|string fold-level
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then return "0" end
  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then return "0" end
  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then return "0" end
  local ok = pcall(vim.treesitter.get_parser, buf)
  if not ok then vim.opt_local.relativenumber = false end
  if ok then return vim.treesitter.foldexpr() end
  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

---Returns a list of regular and extmark signs sorted by priority (low to high)
---@alias util.sign {name:string, text:string, texthl:string, priority:number}
---@return util.sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- regular signs
  local signs = {} ---@type util.sign[]
  -- extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or extmark[4].sign_name or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end
  table.sort(signs, function(a, b) return (a.priority or 0) < (b.priority or 0) end)
  return signs
end

---@param sign? util.sign
---@param len? number
local get_icon = function(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

---@return util.sign?
---@param buf number
---@param lnum number
local get_mark = function(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match "[a-zA-Z]" then
      return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
    end
  end
end

---Determine what content is shown on the side of a window, e.g. sign, fold and number
function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"
  local components = { "", "", "" } -- left, middle, right
  if show_signs then
    local signs = M.get_signs(buf, vim.v.lnum)
    ---@type util.sign?,util.sign?,util.sign?
    local left, right, fold, githl
    for _, s in ipairs(signs) do
      -- NOTE: gitsigns.nvim
      if s.name and (s.name:find "GitSign") then
        right = s
        githl = s["texthl"]
      else
        left = s
      end
    end
    vim.api.nvim_win_call(win, function()
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = githl or "Folded" }
      elseif not M.skip_foldexpr[buf] and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">" then
        fold = { text = vim.opt.fillchars:get().foldopen or "", texthl = githl }
      end
    end)
    -- Left: mark or non-git sign
    components[1] = get_icon(get_mark(buf, vim.v.lnum) or left)
    -- Right: fold icon or git sign (only if file)
    components[3] = is_file and get_icon(fold or right) or ""
  end
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then components[2] = "%=%l " end
  if vim.v.virtnum ~= 0 then components[2] = "%= " end
  return table.concat(components, "")
end

return M
