local util = require "util"

vim.api.nvim_create_user_command(
  "Scratch",
  function(args) util.buffer.create_scratch(args.fargs[1]) end,
  { nargs = "?", complete = "filetype" }
)

vim.api.nvim_create_user_command("Glow", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  if ft ~= "markdown" then
    error(("Previewer not valid for '%s' files"):format(ft))
    return
  end

  local width = vim.api.nvim_get_option "columns"
  local height = vim.api.nvim_get_option "lines"
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

  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "md_preview")
  vim.api.nvim_win_set_option(win, "winblend", 0)
  vim.keymap.set("n", "q", close_win, { buffer = buf, silent = true })
  vim.keymap.set("n", "<esc>", close_win, { buffer = buf, silent = true })

  local path = vim.api.nvim_buf_get_name(bufnr)
  path = vim.fs.normalize(path)
  vim.fn.termopen(string.format("glow %s", vim.fn.shellescape(path)))
end, {})

vim.api.nvim_create_user_command("ToggleWord", function()
  local lut = {
    ["on"] = "off",
    ["true"] = "false",
    ["yes"] = "no",
    ["correct"] = "incorrect",
    ["higher"] = "lower",
    ["max"] = "min",
    ["maximum"] = "minimum",
    ["open"] = "close",
  }
  vim.tbl_add_reverse_lookup(lut)
  local word = vim.fn.expand "<cword>"
  vim.schedule(function()
    local keys = vim.tbl_keys(lut)
    local search = word:lower()
    if vim.tbl_contains(keys, word:lower()) then
      local match = lut[search]
      if word == word:upper() then
        match = match:upper()
      elseif word == ("%s%s"):format(word:sub(1, 1):upper(), word:sub(2, -1)) then
        match = ("%s%s"):format(match:sub(1, 1):upper(), match:sub(2, -1))
      end
      vim.cmd.normal { args = { ("ciw%s"):format(match) } }
    end
  end)
end, {})
