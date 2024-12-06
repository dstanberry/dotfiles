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

---@class util.buffer.delete.opts
---@field buf? number Buffer to delete. Defaults to the current buffer
---@field force? boolean Delete the buffer even if it is modified
---@field filter? fun(buf: number): boolean Filter buffers to delete
---@field wipe? boolean Wipe the buffer instead of deleting it (see `:h :bwipeout`)

--- Delete and unload a buffer:
--- - either the current buffer if `buf` is not provided
--- - or the buffer `buf` if it is a number
--- - or every buffer for which `buf` returns true if it is a function
---@param opts? number|util.buffer.delete.opts
function M.delete(opts)
  opts = opts or {}
  opts = type(opts) == "number" and { buf = opts } or opts
  opts = type(opts) == "function" and { filter = opts } or opts ---@cast opts util.buffer.delete.opts
  if type(opts.filter) == "function" then
    for _, b in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
      if vim.bo[b].buflisted then M.delete(vim.tbl_extend("force", {}, opts, { buf = b, filter = false })) end
    end
    return
  end
  local buf = opts.buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  vim.api.nvim_buf_call(buf, function()
    if vim.bo.modified and not opts.force then
      local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
      if choice == 0 or choice == 3 then return end
      if choice == 1 then vim.cmd.write() end
    end
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.api.nvim_win_call(win, function()
        if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
        local alt = vim.fn.bufnr "#"
        if alt ~= buf and vim.fn.buflisted(alt) == 1 then
          vim.api.nvim_win_set_buf(win, alt)
          return
        end
        local has_previous = pcall(vim.cmd, "bprevious")
        if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end
        local new_buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_win_set_buf(win, new_buf)
      end)
    end
    if vim.api.nvim_buf_is_valid(buf) then pcall(vim.cmd, (opts.wipe and "bwipeout! " or "bdelete! ") .. buf) end
  end)
end

local realpath = function(path) return (vim.uv.fs_realpath(path) or path) end

---Edit a new file relative to the same directory as the current buffer
function M.edit()
  local buf = vim.api.nvim_get_current_buf()
  local file = realpath(vim.api.nvim_buf_get_name(buf))
  local root = assert(realpath(vim.uv.cwd() or "."))
  if file:find(root, 1, true) ~= 1 then root = vim.fs.dirname(file) end
  vim.ui.input({
    prompt = "File Name: ",
    default = vim.fs.joinpath(root, ""),
    completion = "file",
  }, function(newfile)
    if not newfile or newfile == "" or newfile == file:sub(#root + 2) then return end
    newfile = vim.fs.normalize(vim.fs.joinpath(root, newfile))
    vim.cmd.edit(newfile)
  end)
end

---@alias util.buffer.selection.start {start_line: number, start_col: number} {row,col} mark-indexed position.
---@alias util.buffer.selection.end {start_line: number, start_col: number} {row,col} mark-indexed position.
---@alias util.buffer.selection.opts {selected_lines: string[], start_pos: util.buffer.selection.start, end_pos: util.buffer.selection.end}

---Captures the currently selected region of text
---@return util.buffer.selection.opts # Table containing the selection (accuracy is not guaranteed)
---and two row-column tuples of the start and end of the range
function M.get_line_selection()
  local start_char, end_char = "'<", "'>"
  vim.cmd "normal! "
  local start_line, start_col = unpack(vim.fn.getpos(start_char), 2, 3)
  local end_line, end_col = unpack(vim.fn.getpos(end_char), 2, 3)
  if end_col > 0 then
    end_col = vim.lsp.util.character_offset(0, end_line, end_col, "utf-16")
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
---@return string|string[]|table, util.buffer.selection.opts #Table containing each line of the selected range
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

---@class util.buffer.filter.opts
---@field loaded? boolean Filter out buffers that aren't loaded.
---@field listed? boolean Filter out buffers that aren't listed.
---@field no_hidden? boolean Filter out buffers that are hidden.
---@field tabpage? integer Filter out buffers that are not displayed in a given tabpage.
---@field pattern? string Filter out buffers whose name does not match a given lua pattern.
---@field options? table<string, any> Filter out buffers that don't match a given map of options.
---@field vars? table<string, any> Filter out buffers that don't match a given map of variables.

---@param opts? util.buffer.filter.opts
---@return integer[] #Buffer numbers of matched buffers.
function M.filter(opts)
  opts = opts or {}
  local bufs
  if opts.no_hidden or opts.tabpage then
    local wins = opts.tabpage and vim.api.nvim_tabpage_list_wins(opts.tabpage) or vim.api.nvim_list_wins()
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
    if opts.loaded and not vim.api.nvim_buf_is_loaded(bufnr) then return false end
    if opts.listed and not vim.bo[bufnr].buflisted then return false end
    if opts.pattern and not vim.api.nvim_buf_get_name(bufnr):match(opts.pattern) then return false end
    if opts.options then
      for name, value in pairs(opts.options) do
        if vim.bo[bufnr][name] ~= value then return false end
      end
    end
    if opts.vars then
      for name, value in pairs(opts.vars) do
        if vim.b[bufnr][name] ~= value then return false end
      end
    end
    return true
  end, bufs)
end

---@alias util.buffer.lsp.range_params {textDocument: { uri: string }, range: { start: number, end: number }}

--- Custom implementation of `vim.lsp.util.make_range_params()`
---@return util.buffer.lsp.range_params
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
---@param buf integer?
function M.quickfix_delete(buf)
  buf = buf or vim.api.nvim_get_current_buf()
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
  vim.fn.setpos(".", { buf, line, 1, 0 })
  vim.api.nvim_replace_termcodes("<esc>", true, false, true)
end

---Change the filename (and/or filepath) of the current buffer given that it exists on disk.
---If supported, the workspace can be updated with the updated filename
function M.rename()
  local buf = vim.api.nvim_get_current_buf()
  local oldfile = assert(realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(realpath(vim.uv.cwd() or "."))
  if oldfile:find(root, 1, true) ~= 1 then root = vim.fs.dirname(oldfile) end
  local cwd = oldfile:sub(#root + 2)
  vim.ui.input({
    prompt = "New File Name: ",
    default = cwd,
    completion = "file",
  }, function(newfile)
    if not newfile or newfile == "" or newfile == cwd then return end
    newfile = vim.fs.normalize(vim.fs.joinpath(root, newfile))
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
