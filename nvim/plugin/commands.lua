vim.api.nvim_create_user_command(
  "Scratch",
  function(args) ds.buffer.create_scratch(args.fargs[1]) end,
  { nargs = "?", complete = "filetype" }
)

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
          pcall(vim.lsp.buf.rename, match)
        end
      end
      if not renamed then vim.cmd.normal { args = { ("ciw%s"):format(match) } } end
    end)
  end
end, {})
