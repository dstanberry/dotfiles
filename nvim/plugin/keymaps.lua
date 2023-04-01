local util = require "util"

---------------------------------------------------------------
-- => Normal
---------------------------------------------------------------
-- (spacefn) scroll current buffer
vim.keymap.set("n", "<up>", "<c-y>", { desc = "scroll up" })
vim.keymap.set("n", "<down>", "<c-e>", { desc = "scroll down" })

-- switch to next buffer
vim.keymap.set("n", "<right>", function()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then vim.cmd.bnext() end
  bufferline.cycle(1)
end, { desc = "next buffer" })
-- switch to previous buffer
vim.keymap.set("n", "<left>", function()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then vim.cmd.bprevious() end
  bufferline.cycle(-1)
end, { desc = "previous buffer" })

-- switch to next tab
vim.keymap.set("n", "<tab>", vim.cmd.tabnext, { desc = "next tab" })
-- switch to previous tab
vim.keymap.set("n", "<s-tab>", vim.cmd.tabprevious, { desc = "previous tab" })

-- clear hlsearch if set, otherwise send default behaviour
vim.keymap.set("n", "<cr>", function()
  if vim.v.hlsearch then
    vim.cmd.nohl()
  else
    vim.cmd.normal "<cr>"
  end
end, { desc = "clear |hlsearch|" })

-- navigate quickfix list
vim.keymap.set("n", "<c-up>", function() pcall(vim.cmd.cprevious) end, { desc = "previous item in quickfix list" })
vim.keymap.set("n", "<c-down>", function() pcall(vim.cmd.cnext) end, { desc = "next item in quickfix list" })

-- navigate location list
vim.keymap.set("n", "<a-up>", function() pcall(vim.cmd.lprevious) end, { desc = "previous entry in location list" })
vim.keymap.set("n", "<a-down>", function() pcall(vim.cmd.lnext) end, { desc = "next entry in location list" })

-- find all occurences in buffer of word under cursor
vim.keymap.set(
  "n",
  "<c-w><c-f>",
  function() return ("/%s<cr>"):format(vim.fn.expand "<cword>") end,
  { silent = false, expr = true, desc = "find occurences of word under cursor" }
)

-- show highlight information for word under cursor
vim.keymap.set("n", "<c-w><c-i>", vim.show_pos, { desc = "show highlights for word under cursor" })

-- shift current line down
vim.keymap.set("n", "<c-w><c-j>", ":m .+1<cr>==", { desc = "move line down" })
-- shift current line up
vim.keymap.set("n", "<c-w><c-k>", ":m .-2<cr>==", { desc = "move line up" })

-- begin substitution in buffer for word under cursor
vim.keymap.set(
  "n",
  "<c-w><c-r>",
  function() return ([[:%%s/\<%s\>/]]):format(vim.fn.expand "<cword>") end,
  { silent = false, expr = true, desc = "substitute occurences of word under cursor" }
)

-- change the word under the cursor to it's semantic opposite
vim.keymap.set(
  "n",
  "<c-w><c-t>",
  function() vim.cmd { cmd = "ToggleWord" } end,
  { silent = false, desc = "substitute word under cursor with antonym" }
)

-- -- switch to left window
-- vim.keymap.set("n", "<c-h>", "<c-w><c-h>")
-- -- switch to bottom window
-- vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
-- -- switch to top window
-- vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
-- -- switch to right window
-- vim.keymap.set("n", "<c-l>", "<c-w><c-l>")

-- decrease active split horizontal size
vim.keymap.set("n", "<a-h>", "<c-w><", { desc = "decrease window width" })
-- increase active split horizontal size
vim.keymap.set("n", "<a-l>", "<c-w>>", { desc = "increase window width" })
-- decrease active split vertical size
vim.keymap.set("n", "<a-j>", "<c-w>-", { desc = "decrease window height" })
-- increase active split vertical size
vim.keymap.set("n", "<a-k>", "<c-w>+", { desc = "increase window height" })

-- (try to) make all windows the same size
vim.keymap.set("n", "==", "<c-w>=", { desc = "set all windows to the same height/width" })

-- allow semi-colon to enter command mode
vim.keymap.set("n", ";", ":", { silent = false, desc = "enter command-line mode" })

-- change text and preserve clipboard state
vim.keymap.set("n", "c", '"_c', { silent = false, desc = "+change (preserve clipboard)" })
vim.keymap.set("n", "C", '"_C', { silent = false, desc = "change to end of line (preserve clipboard)" })

-- trim trailing whitespace
vim.keymap.set("n", "FF", function()
  for ln, str in ipairs(vim.fn.getline(1, "$")) do
    local sub = str:match "(.*%S)" or str
    vim.fn.setline(ln, sub)
  end
end, { silent = false, desc = "trim trailing whitespace" })

-- move to the beginning of the current line
vim.keymap.set("n", "H", "^", { desc = "goto start of line" })
-- move to the end of the current line
vim.keymap.set("n", "L", "g_", { desc = "goto end of line" })

-- keep cursor stationary when joining line(s) below
vim.keymap.set("n", "J", "mzJ`z", { desc = "join with line below" })

-- maintain direction when cycling between searches
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "next occurence" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "previous occurence" })

-- insert newline without entering insert mode
vim.keymap.set("n", "o", "o<esc>", { desc = "insert line below" })
vim.keymap.set("n", "O", "O<esc>", { desc = "insert line above" })

-- disable recording to a register
vim.keymap.set("n", "q", "<nop>", { desc = "<disabled>" })

-- avoid unintentional switches to Ex mode.
vim.keymap.set("n", "Q", "<nop>", { desc = "<disabled>" })

-- yank to end of line
vim.keymap.set("n", "Y", "y$", { desc = "copy to end of line" })

---------------------------------------------------------------
-- => Normal | LocalLeader
---------------------------------------------------------------
-- prepare to run most recent ex-command
vim.keymap.set("n", "<localleader><localleader>c", ":<up>", { silent = false, desc = "run last command" })

-- create/edit file within the current directory
vim.keymap.set("n", "<localleader><localleader>e", function()
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return (":edit %s%s"):format(path, "/")
end, { silent = false, expr = true, replace_keycodes = true, desc = "create/edit file relative to current document" })

-- prepare to call |reload()| on the current lua file
vim.keymap.set("n", "<localleader><localleader>r", function()
  if vim.bo.filetype ~= "lua" then error "reload utility only available for lua modules" end
  local file = vim.api.nvim_buf_get_name(0)
  local mod = util.get_module_name(file)
  local shift = ""
  if #mod == 0 then shift = "<left><left>" end
  return ([[:lua reload("%s")%s]]):format(mod, shift)
end, { silent = false, expr = true, replace_keycodes = true, desc = "reload current lua module" })

-- save as new file within the current directory (with the option to delete the original)
vim.keymap.set("n", "<localleader><localleader>s", function()
  local file = vim.api.nvim_buf_get_name(0)
  local path = vim.fs.dirname(file)
  ---@diagnostic disable-next-line: redundant-parameter
  local updated = vim.fn.input("Save as: ", path .. "/")
  if #updated > 0 and updated ~= file then
    vim.cmd.saveas(updated)
    local move = vim.fn.confirm("Delete original file?", "&Yes\n&No")
    if move == 1 then
      vim.fn.delete(file)
      vim.cmd.bdelete(file)
    end
  end
end, { silent = false, desc = "save as" })

-- save current buffer to disk and execute the file
vim.keymap.set("n", "<localleader><localleader>x", function()
  local ft = vim.bo.filetype
  print(vim.cmd.write())
  if ft == "vim" then
    print(vim.cmd.source "%")
  elseif ft == "lua" then
    print(vim.cmd.luafile "%")
  end
end, { silent = false, desc = "save and execute current document" })

---------------------------------------------------------------
-- => Normal | 'Third' Leader Prefix
---------------------------------------------------------------
-- delete text and preserve clipboard state
vim.keymap.set("n", "<bs>d", '"_d', { silent = false, desc = "+delete (preserve clipboard)" })
vim.keymap.set("n", "<bs>D", '"_D', { silent = false, desc = "delete to end of line (preserve clipboard)" })

-- paste text and preserve clipboard state
vim.keymap.set("n", "<bs>p", '"_p', { silent = false, desc = "paste (preserve clipboard)" })
vim.keymap.set("n", "<bs>P", '"_P', { silent = false, desc = "paste (preserve clipboard)" })

-- discard all file modifications to current window
vim.keymap.set("n", "<bs>q", function() vim.cmd.quit { bang = true } end, { desc = "close current window" })

-- discard all file modifications and close instance
vim.keymap.set("n", "<bs>Q", function() vim.cmd.quitall { bang = true } end, { desc = "close application" })

-- close the current buffer
vim.keymap.set(
  "n",
  "<bs>z",
  function() util.buffer.delete_buffer(false) end,
  { silent = false, desc = "close current buffer" }
)

-- discard changes to current buffer and close it
vim.keymap.set(
  "n",
  "<bs>Z",
  function() util.buffer.delete_buffer(true) end,
  { silent = false, desc = "discard changes and close current buffer" }
)

---------------------------------------------------------------
-- => Insert
---------------------------------------------------------------
-- insert newline above current line
vim.keymap.set("i", "<c-enter>", "<c-o>O")
-- insert newline below current line
vim.keymap.set("i", "<a-enter>", "<c-o>o")

-- delete all text to the right of the curor
vim.keymap.set("i", "<c-s-del>", "<c-o>D")

-- go to the beginning of the current line
vim.keymap.set("i", "<c-a>", "<c-o>^")
-- go to the end of the current line
vim.keymap.set("i", "<c-e>", "<c-o>$")

-- shift current line down
vim.keymap.set("i", "<c-j>", "<esc>:m .+1<cr>==i")
-- shift current line up
vim.keymap.set("i", "<c-k>", "<esc>:m .-2<cr>==i")

-- forward delete the next word
vim.keymap.set("i", "<a-w>", "<c-o>cW")

-- define undo break point
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- exit insert mode
vim.keymap.set("i", "jk", "<esc>")

---------------------------------------------------------------
-- => Visual
---------------------------------------------------------------
-- move between windows.
vim.keymap.set("v", "<c-h>", "<c-w>h", { desc = "goto left window" })
vim.keymap.set("v", "<c-j>", "<c-w>j", { desc = "goto lower window" })
vim.keymap.set("v", "<c-k>", "<c-w>k", { desc = "goto upper window" })
vim.keymap.set("v", "<c-l>", "<c-w>l", { desc = "goto right window" })

-- begin substitution in buffer for visual selection
vim.keymap.set("v", "<c-w><c-r>", function()
  local lines = util.buffer.get_visual_selection()
  local selection = table.concat(lines)
  return (":<c-u>%%s/%s/"):format(selection)
end, { silent = false, expr = true, replace_keycodes = true, desc = "replace occurences of selection" })

-- execute selected text (for vim/lua files)
vim.keymap.set("v", "<c-w><c-x>", function()
  local function eval_chunk(str, ...)
    local chunk = loadstring(str, "@[evalrangeX]")
    local c = coroutine.create(chunk)
    local res = { coroutine.resume(c, ...) }
    if not res[1] then
      if debug.getinfo(c, 0, "f").func ~= chunk then res[2] = debug.traceback(c, res[2], 0) end
    end
    return unpack(res)
  end
  local lines = util.buffer.get_visual_selection()
  local selection = table.concat(lines)
  local ft = vim.bo.filetype
  local out = ""
  if ft == "vim" then
    out = vim.api.nvim_exec(([[%s]]):format(selection), true)
  elseif ft == "lua" then
    out = eval_chunk(selection)
  end
  print(out)
end, { silent = true, desc = "execute selection" })

-- maintain selection after indentation
vim.keymap.set("v", "<", "<gv", { desc = "indent selection" })
vim.keymap.set("v", ">", ">gv", { desc = "un-indent selection" })

-- allow semi-colon to enter command mode
vim.keymap.set("v", ";", ":", { silent = false, desc = "enter command-line mode" })

-- move selection to the beginning of the current line
vim.keymap.set("v", "H", "^", { desc = "extend selection to start of line" })
-- move selection to the end of the current line
vim.keymap.set("v", "L", "g_", { desc = "extend selection to end of line" })

-- shift selected text down
vim.keymap.set("x", "<c-down>", ":move '>+<cr>gv=gv", { desc = "move selection up" })
-- shift selected text up
vim.keymap.set("x", "<c-up>", ":move -2<cr>gv=gv", { desc = "move selection down" })

---------------------------------------------------------------
-- => Command
---------------------------------------------------------------
-- move to the beginning of the command
vim.keymap.set("c", "<c-a>", "<home>", { silent = false, desc = "goto start of line" })
-- move to the end of the command
vim.keymap.set("c", "<c-e>", "<end>", { silent = false, desc = "goto end of line" })

-- navigate completion menu using up key
vim.keymap.set("c", "<up>", function()
  local ok, cmp = pcall(require, "cmp")
  local visible = false
  if ok then visible = cmp.visible() end
  if vim.fn.pumvisible() == 1 or visible then
    return "<c-p>"
  else
    return "<up>"
  end
end, { silent = false, expr = true, replace_keycodes = true })

-- navigate completion menu using down key
vim.keymap.set("c", "<down>", function()
  local ok, cmp = pcall(require, "cmp")
  local visible = false
  if ok then visible = cmp.visible() end
  if vim.fn.pumvisible() == 1 or visible then
    return "<c-n>"
  else
    return "<down>"
  end
end, { silent = false, expr = true, replace_keycodes = true })

-- exit command mode
vim.keymap.set("c", "jk", "<c-c>", { desc = "leave command-line mode" })

-- populate command line with path to parent dir of current buffer
vim.keymap.set(
  "c",
  "%H",
  function() return vim.fs.dirname(vim.api.nvim_buf_get_name(0)) .. "/" end,
  { silent = false, expr = true, replace_keycodes = true, desc = "insert path to parent directory" }
)

-- populate command line with path to file of current buffer
vim.keymap.set(
  "c",
  "%P",
  function() return vim.fs.normalize(vim.api.nvim_buf_get_name(0)) end,
  { silent = false, expr = true, replace_keycodes = true, desc = "insert filepath" }
)

---------------------------------------------------------------
-- => Terminal
---------------------------------------------------------------
-- leave terminal mode
vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "leave terminal mode" })

-- switch to left window
vim.keymap.set("t", "<c-h>", [[<c-\><c-n><c-w>h]], { desc = "goto left window" })
-- switch to bottom window
vim.keymap.set("t", "<c-j>", [[<c-\><c-n><c-w>j]], { desc = "goto lower window" })
-- switch to top twindow
vim.keymap.set("t", "<c-k>", [[<c-\><c-n><c-w>k]], { desc = "goto upper window" })
-- switch to right window
vim.keymap.set("t", "<c-l>", [[<c-\><c-n><c-w>l]], { desc = "goto right window" })
