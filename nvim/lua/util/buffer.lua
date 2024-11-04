---@class util.buffer
local M = {}

---Creates a sandboxed buffer that cannot be saved but has highlighting enabled for the filetype
---@param filetype string
function M.create_scratch(filetype)
  local create_buf = function(ft)
    vim.cmd.new { args = { "[Scratch]" }, range = { 20 } }
    vim.bo.bufhidden = "wipe"
    vim.bo.buflisted = false
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false
    vim.bo.filetype = ft or vim.bo.filetype
  end
  if filetype then return create_buf(filetype) end
  vim.ui.input({
    prompt = "scratch buffer filetype: ",
    default = vim.bo.filetype,
    completion = "filetype",
  }, function(ft) return create_buf(ft) end)
end

---Unloads a buffer
---@param buf number?
function M.delete(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then return end
    if choice == 1 then vim.cmd.write() end
  end
  local wins = vim.tbl_filter(function(win) return vim.api.nvim_win_get_buf(win) == buf end, vim.api.nvim_list_wins())
  for _, win in ipairs(wins) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
      local alt = vim.fn.bufnr "#"
      if alt >= 0 and alt ~= buf and vim.bo[alt].buflisted then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then pcall(vim.cmd, "bdelete! " .. buf) end
end

---@alias util.buffer_startLine {start_line: number, start_col: number} {row,col} mark-indexed position.
---@alias util.buffer_endLine {start_line: number, start_col: number} {row,col} mark-indexed position.
---@alias util.buffer_selection { selected_lines: string[], start_pos: util.buffer_startLine, end_pos: util.buffer_endLine }

---Captures the currently selected region of text
---@return util.buffer_selection # Table containing the selection (accuracy is not guaranteed)
---and two row-column tuples of the start and end of the range
function M.get_line_selection()
  local start_char, end_char = "'<", "'>"
  vim.cmd "normal! "
  local offset_encoding = vim.lsp.util._get_offset_encoding(0)
  local start_line, start_col = unpack(vim.fn.getpos(start_char), 2, 3)
  local end_line, end_col = unpack(vim.fn.getpos(end_char), 2, 3)
  if end_col > 0 then
    end_col = vim.lsp.util.character_offset(0, end_line, end_col, offset_encoding)
    if end_col == 0 then end_col = #vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1] + 1 end
  end
  local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return {
    selected_lines = selected_lines,
    start_pos = { start_line, start_col },
    end_pos = { end_line, end_col },
  }
end

---Captures the currently selected region of text
---@return string|string[]|table, util.buffer_selection #Table containing each line of the selected range
---(accuracy is guaranteed) and a table containing the two row-column tuples of the start and end of the range
function M.get_visual_selection()
  local res = M.get_line_selection()
  local mode = vim.fn.visualmode()
  local start_line, start_col = unpack(res.start_pos)
  local end_line, end_col = unpack(res.end_pos)
  local range = { { start_line, start_col }, { end_line, end_col } }
  local selection = ""
  -- line-visual
  if mode == "V" then selection = res.selected_lines end
  if mode == "v" then
    -- visual
    if vim.opt.selection:get() == "exclusive" then end_col = end_col - 1 end
    selection = vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
  end
  -- block-visual
  if mode == "\x16" then
    if vim.opt.selection:get() == "exclusive" then end_col = end_col - 1 end
    if start_col > end_col then
      start_col, end_col = end_col, start_col
    end
    selection = vim.tbl_map(function(line) return line:sub(start_col, end_col) end, res.selected_lines)
  end
  return selection, range
end

---@class ListBufsSpec
---@field loaded? boolean Filter out buffers that aren't loaded.
---@field listed? boolean Filter out buffers that aren't listed.
---@field no_hidden? boolean Filter out buffers that are hidden.
---@field tabpage? integer Filter out buffers that are not displayed in a given tabpage.
---@field pattern? string Filter out buffers whose name does not match a given lua pattern.
---@field options? table<string, any> Filter out buffers that don't match a given map of options.
---@field vars? table<string, any> Filter out buffers that don't match a given map of variables.

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

---@alias util.buffer_lsp_range_params { textDocument: { uri: string }, range: { start: number, end: number } }

--- Custom implementation of `vim.lsp.util.make_range_params()`
---@return util.buffer_lsp_range_params
function M.make_lsp_range_params(range)
  local params = {}
  ds.foreach({ "start", "end" }, function(v, k)
    local row, col = unpack(range[k])
    col = (vim.o.selection ~= "exclusive" and v == "end") and col + 1 or col
    params[v] = { line = row == 0 and row or row - 1, character = col == 0 and col or col - 1 }
  end)
  return {
    ["range"] = params,
    textDocument = { uri = vim.uri_from_bufnr(0) },
  }
end

---Delete current line or selected range from quickfix list
---@param bufnr integer?
function M.quickfix_delete(bufnr)
  bufnr = vim.F.if_nil(bufnr, vim.api.nvim_get_current_buf())
  local qfl = vim.fn.getqflist()
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  if string.lower(vim.api.nvim_get_mode().mode) == "v" then
    local _, range = M.get_visual_selection()
    local firstline = range[1][2]
    local lastline = range[2][2]
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

---Change the filename (and/or filepath) of the current buffer given that it exists on disk.
---If supported, the workspace can be updated with the updated filename
function M.rename()
  local realpath = function(path) return (vim.uv.fs_realpath(path) or path) end
  local buf = vim.api.nvim_get_current_buf()
  local oldfile = assert(realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(realpath(vim.uv.cwd() or "."))

  if oldfile:find(root, 1, true) ~= 1 then root = vim.fn.fnamemodify(oldfile, ":p:h") end
  local cwd = oldfile:sub(#root + 2)

  vim.ui.input({
    prompt = "New File Name: ",
    default = cwd,
    completion = "file",
  }, function(newfile)
    if not newfile or newfile == "" or newfile == cwd then return end
    newfile = vim.fs.normalize(root .. "/" .. newfile)
    vim.fn.mkdir(vim.fs.dirname(newfile), "p")
    require("remote.lsp.handlers").on_rename(oldfile, newfile, function()
      vim.fn.rename(oldfile, newfile)
      vim.cmd.edit(newfile)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(oldfile)
    end)
  end)
end

---Takes the content of the current buffer and displays them in a terminal buffer
function M.send_to_term()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>qa!<cr>", { buffer = buf, silent = true })
  vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end

return M
