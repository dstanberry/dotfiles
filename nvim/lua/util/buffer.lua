local M = {}

---Creates a sandboxed buffer that cannot be saved but has highlighting enabled for the filetype
---@param filetype string
function M.create_scratch(filetype)
  if not filetype or filetype == "" then filetype = vim.fn.input "scratch buffer filetype: " end
  vim.cmd.new { args = { "[Scratch]" }, range = { 20 } }
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  if filetype then vim.bo.filetype = filetype end
end

---Unloads a buffer and if the buffer was in a split, the split is preserved.
---@param force boolean
function M.delete_buffer(force)
  local buffers = M.list_buffers { listed = true }
  if #buffers < 2 then
    vim.cmd.enew()
    return
  end
  local w_id = vim.api.nvim_get_current_win()
  local winnr = vim.api.nvim_win_get_number(w_id)
  local bufnr = vim.api.nvim_win_get_buf(w_id)
  -- TODO: replace |getbufinfo()| with lua api
  for _, winid in ipairs(vim.fn.getbufinfo(bufnr)[1].windows) do
    vim.cmd.wincmd { args = { "w" }, range = { vim.api.nvim_win_get_number(winid) } }
    if bufnr == buffers[#buffers] then
      vim.cmd.bprevious()
    else
      vim.cmd.bnext()
    end
  end
  vim.cmd.wincmd { args = { "w" }, range = { winnr } }
  if force or vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
    vim.cmd.bdelete { args = { "#" }, bang = true }
  else
    vim.cmd.bdelete { args = { "#" }, mods = { emsg_silent = true, confirm = true } }
  end
end

---Customizes the appearance of folded text in a buffer
---@return string
function M.fold_text()
  local indent = vim.fn.indent(vim.v.foldstart - 1)
  local indent_level = vim.fn["repeat"](" ", indent)
  local line_count = string.format("%s lines", (vim.v.foldend - vim.v.foldstart + 1))
  local header = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]:gsub(" *", "", 1)
  local width = vim.fn.winwidth(0) - vim.wo.foldcolumn - (vim.wo.number and 8 or 0)
  local lhs = string.format("%s%s", indent_level, header)
  local rhs = string.format("%s  · %s", vim.v.foldlevel, line_count)
  local separator = vim.fn["repeat"](" ", width - vim.fn.strwidth(lhs) - vim.fn.strwidth(rhs))
  return string.format("%s %s%s ", lhs, separator, rhs)
end

---Defines the conditions that determine how the text at the current cursor position might be folded
---@return integer|string fold-level
function M.fold_expr()
  if string.find(vim.fn.getline(vim.v.lnum), "%S") == nil then return "-1" end
  local get_indent_level = function(n) return vim.fn.indent(n) / vim.bo.shiftwidth end
  local get_next_line_with_content = function()
    local count = vim.fn.line "$"
    local line = vim.v.lnum + 1
    while line <= count do
      if string.find(vim.fn.getline(line), "%S") ~= nil then return line end
      line = line + 1
    end
    return -2
  end
  local current = get_indent_level(vim.v.lnum)
  local next = get_indent_level(get_next_line_with_content())
  if next <= current then return current end
  return ">" .. next
end

---Return the root directory for the current document based on:
---* lsp workspace folders
---* lsp root_dir
---* root pattern of filename of the current buffer
---* root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find({ ".git" }, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

local get_marked_region = function(mark1, mark2, options)
  local bufnr = 0
  local adjust = options.adjust or function(pos1, pos2) return pos1, pos2 end
  local regtype = options.regtype or vim.fn.visualmode()
  local selection = options.selection or (vim.o.selection ~= "exclusive")
  local pos1 = vim.fn.getpos(mark1)
  local pos2 = vim.fn.getpos(mark2)
  pos1, pos2 = adjust(pos1, pos2)
  if options.positions then return "", pos1, pos2 end
  local start = { pos1[2] - 1, pos1[3] - 1 + pos1[4] }
  local finish = { pos2[2] - 1, pos2[3] - 1 + pos2[4] }
  if start[2] < 0 or finish[1] < start[1] then return end
  local region = vim.region(bufnr, start, finish, regtype, selection)
  return region, start, finish
end

---@class VisualSelectionSpec
---@field positions boolean Request the result be a table containing
---the row and column for the start and end of the selected range

---Captures the currently selected region of text
---@param opt? VisualSelectionSpec
---@return table, table? #Table containing each line of the selected range
---and/or a table containing the row-column of the start and end of the range
function M.get_visual_selection(opt)
  opt = vim.F.if_nil(opt, {})
  local bufnr = 0
  local visual_modes = {
    v = true,
    V = true,
  }
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then return {} end
  local options = {}
  ---@diagnostic disable-next-line: need-check-nil
  options.positions = vim.F.if_nil(opt.positions, false)
  options.adjust = function(pos1, pos2)
    if vim.fn.mode() == "V" then
      pos1[3] = 1
      pos2[3] = 2 ^ 31 - 1
    end
    if pos1[2] > pos2[2] then
      pos2[3], pos1[3] = pos1[3], pos2[3]
      return pos2, pos1
    elseif pos1[2] == pos2[2] and pos1[3] > pos2[3] then
      return pos2, pos1
    else
      return pos1, pos2
    end
  end
  local region, start, finish = get_marked_region("v", ".", options)
  if options.positions then return { start, finish } end
  if region ~= nil and start ~= nil and finish ~= nil then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start[1], finish[1] + 1, false)
    local line1_end
    if region[start[1]][2] - region[start[1]][1] < 0 then
      line1_end = #lines[1] - region[start[1]][1]
    else
      line1_end = region[start[1]][2] - region[start[1]][1]
    end
    lines[1] = vim.fn.strpart(lines[1], region[start[1]][1], line1_end)
    if start[1] ~= finish[1] then
      lines[#lines] = vim.fn.strpart(lines[#lines], region[finish[1]][1], region[finish[1]][2] - region[finish[1]][1])
    end
    return lines, { start, finish }
  end
  return {}
end

---@class ListBufsSpec
---@field loaded boolean Filter out buffers that aren't loaded.
---@field listed boolean Filter out buffers that aren't listed.
---@field no_hidden boolean Filter out buffers that are hidden.
---@field tabpage integer Filter out buffers that are not displayed in a given tabpage.
---@field pattern string Filter out buffers whose name does not match a given lua pattern.
---@field options table<string, any> Filter out buffers that don't match a given map of options.
---@field vars table<string, any> Filter out buffers that don't match a given map of variables.

---@param opt? ListBufsSpec
---@return integer[] #Buffer numbers of matched buffers.
function M.list_buffers(opt)
  opt = opt or {}
  local bufs
  if opt.no_hidden or opt.tabpage then
    local wins = opt.tabpage and vim.api.nvim_tabpage_list_wins(opt.tabpage) or vim.api.nvim_list_wins()
    local bufnr
    local seen = {}
    bufs = {}
    for _, winid in ipairs(wins) do
      bufnr = vim.api.nvim_win_get_buf(winid)
      if not seen[bufnr] then bufs[#bufs + 1] = bufnr end
      seen[bufnr] = true
    end
  else
    bufs = vim.api.nvim_list_bufs()
  end
  return vim.tbl_filter(function(bufnr)
    if opt.loaded and not vim.api.nvim_buf_is_loaded(bufnr) then return false end
    if opt.listed and not vim.bo[bufnr].buflisted then return false end
    if opt.pattern and not vim.api.nvim_buf_get_name(bufnr):match(opt.pattern) then return false end
    if opt.options then
      for name, value in pairs(opt.options) do
        if vim.bo[bufnr][name] ~= value then return false end
      end
    end
    if opt.vars then
      for name, value in pairs(opt.vars) do
        if vim.b[bufnr][name] ~= value then return false end
      end
    end
    return true
  end, bufs)
end

---Delete current line or selected range from quickfix list
---@param bufnr integer?
function M.quickfix_delete(bufnr)
  bufnr = vim.F.if_nil(bufnr, vim.api.nvim_get_current_buf())
  local qfl = vim.fn.getqflist()
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  if string.lower(vim.api.nvim_get_mode().mode) == "v" then
    local selection = M.get_visual_selection { positions = true }
    local firstline = selection[1][2]
    local lastline = selection[2][2]
    local result = {}
    for i, item in ipairs(qfl) do
      if i < firstline or i > lastline then table.insert(result, item) end
    end
    qfl = result
  else
    table.remove(qfl, line)
  end
  vim.fn.setqflist({}, "r", { items = qfl })
  vim.fn.setpos(".", { bufnr, line, 1, 0 })
  vim.api.nvim_replace_termcodes("<esc>", true, false, true)
end

return M
