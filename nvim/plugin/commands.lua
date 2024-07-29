-- HACK: ...until the nested string wierdness is resolved in `gh/config.sml'
-- [G]it[H]ub [E]dit [I]ssue
vim.api.nvim_create_user_command(
  "GHEI",
  vim.schedule_wrap(function()
    local bufs = ds.buffer.list_buffers { listed = true }
    if #bufs == 1 then
      local path = vim.api.nvim_buf_get_name(bufs[1])
      local fname = vim.fs.basename(path)
      if fname:sub(1, 1) == "#" then
        local pr = fname:match "#(%d+)"
        vim.cmd("Octo issue edit " .. pr)
        vim.api.nvim_buf_delete(bufs[1], { force = true })
      end
    end
  end),
  {}
)

-- HACK: ...until the nested string wierdness is resolved in `gh/config.sml'
-- [G]it[H]ub [E]dit [P]ull [R]equest
vim.api.nvim_create_user_command(
  "GHEPR",
  vim.schedule_wrap(function()
    local bufs = ds.buffer.list_buffers { listed = true }
    if #bufs == 1 then
      local path = vim.api.nvim_buf_get_name(bufs[1])
      local fname = vim.fs.basename(path)
      if fname:sub(1, 1) == "#" then
        local pr = fname:match "#(%d+)"
        vim.cmd("Octo pr edit " .. pr)
        vim.api.nvim_buf_delete(bufs[1], { force = true })
      end
    end
  end),
  {}
)

vim.api.nvim_create_user_command(
  "Scratch",
  function(args) ds.buffer.create_scratch(args.fargs[1]) end,
  { nargs = "?", complete = "filetype" }
)

vim.api.nvim_create_user_command("Glow", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  if ft ~= "markdown" then
    error(("Previewer not valid for '%s' files"):format(ft))
    return
  end

  local width = vim.api.nvim_get_option_value("columns", {})
  local height = vim.api.nvim_get_option_value("lines", {})
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "none",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  local close_win = function() vim.api.nvim_win_close(win, true) end

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "md_preview", { buf = buf })
  vim.api.nvim_set_option_value("winblend", 0, { win = win })
  vim.keymap.set("n", "q", close_win, { buffer = buf, silent = true })
  vim.keymap.set("n", "<esc>", close_win, { buffer = buf, silent = true })

  local path = vim.api.nvim_buf_get_name(bufnr)
  path = vim.fs.normalize(path)
  vim.fn.termopen(string.format("glow %s", vim.fn.shellescape(path)))
end, {})

vim.api.nvim_create_user_command("ToggleWord", function()
  local lut = {
    ["correct"] = "incorrect",
    ["first"] = "last",
    ["high"] = "low",
    ["left"] = "right",
    ["max"] = "min",
    ["on"] = "off",
    ["open"] = "close",
    ["start"] = "end",
    ["true"] = "false",
    ["up"] = "down",
    ["yes"] = "no",
  }
  local word = vim.fn.expand "<cword>"
  local full_match, partial_match = false, nil
  ds.foreach(lut, function(v, k)
    if k == word:lower() or v == word:lower() then full_match = true end
    if k:match(word:lower()) then partial_match = { k, v } end
    if word:lower():match(k) then partial_match = { k, v } end
    if v:match(word:lower()) then partial_match = { v, k } end
    if word:lower():match(v) then partial_match = { v, k } end
  end)
  if full_match or type(partial_match) == "table" then
    vim.schedule(function()
      local match = full_match and lut[word:lower()] or nil
      if type(partial_match) == "table" and not full_match then
        match = ds.replace(word, partial_match[1], partial_match[2])
      elseif match and word == word:upper() then
        match = match:upper()
      elseif match and word == ("%s%s"):format(word:sub(1, 1):upper(), word:sub(2, -1)) then
        match = ("%s%s"):format(match:sub(1, 1):upper(), match:sub(2, -1))
      end
      local renamed = false
      for _, client in pairs(vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }) do
        if client.server_capabilities.documentFormattingProvider then
          renamed = true
          vim.lsp.buf.rename(match)
        end
      end
      if not renamed then vim.cmd.normal { args = { ("ciw%s"):format(match) } } end
    end)
  end
end, {})
