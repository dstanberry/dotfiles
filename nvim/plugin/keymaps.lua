---------------------------------------------------------------
-- => Normal
---------------------------------------------------------------
-- HACK: treat ctrl-i as ctrl-i (... and try to not conflate with <tab>)
-- https://github.com/neovim/neovim/issues/20126
vim.keymap.set("n", "<c-i>", "<c-i>", { noremap = true })

-- (spacefn) scroll current buffer
vim.keymap.set("n", "<up>", "<c-y>", { desc = "scroll up" })
vim.keymap.set("n", "<down>", "<c-e>", { desc = "scroll down" })

-- switch to next buffer
vim.keymap.set("n", "<right>", vim.cmd.bnext, { desc = "next buffer" })
-- switch to previous buffer
vim.keymap.set("n", "<left>", vim.cmd.bprevious, { desc = "previous buffer" })

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
-- show tresitter AST for current buffer
vim.keymap.set("n", "<c-w>`", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input "I"
end, { desc = "inspect treesitter tree" })

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

-- NOTE: handled by |smart-splits.nvim|
-- switch to left window
-- vim.keymap.set("n", "<c-h>", "<c-w><c-h>")
-- switch to bottom window
-- vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
-- switch to top window
-- vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
-- switch to right window
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
    local sub = str:match "(.*%S)" or str:gsub("\r", "")
    vim.fn.setline(ln, sub)
  end
end, { silent = false, desc = "trim trailing whitespace" })

-- disable `gr-default` keymaps
vim.keymap.set("n", "gr", "gr", { nowait = true })
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")

-- move to the beginning of the current line
vim.keymap.set("n", "H", "^", { desc = "goto start of line" })
-- move to the end of the current line
vim.keymap.set("n", "L", "g_", { desc = "goto end of line" })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "up", expr = true, silent = true })

-- keep cursor stationary when joining line(s) below
-- stylua: ignore
vim.keymap.set("n", "J", function()
    vim.cmd [[
      normal! mzJ`z
      delmarks z
    ]]
end, { desc = "join with line below" })

-- maintain direction when cycling between searches
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "next occurence" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "previous occurence" })
vim.keymap.set({ "o", "x" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "next occurence" })
vim.keymap.set({ "n", "o", "x" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "previous occurence" })

-- insert newline without entering insert mode
vim.keymap.set("n", "o", "o<esc>", { desc = "insert line below" })
vim.keymap.set("n", "O", "O<esc>", { desc = "insert line above" })

-- avoid unintentional switches to Ex mode.
vim.keymap.set("n", "Q", "<nop>", { desc = "<disabled>" })

-- yank to end of line
vim.keymap.set("n", "Y", "y$", { desc = "copy to end of line" })

---------------------------------------------------------------
-- => Normal | Operator-Pending
---------------------------------------------------------------
-- perform motion to beginning of the current line
vim.keymap.set("o", "H", "^", { desc = "to start of line" })
-- perform motion to end of the current line
vim.keymap.set("o", "L", "g_", { desc = "to end of line" })

---------------------------------------------------------------
-- => Normal | LocalLeader
---------------------------------------------------------------
-- prepare to run most recent ex-command
vim.keymap.set("n", "<localleader><localleader>c", ":<up>", { silent = false, desc = "run last command" })

-- create/edit file within the current directory
vim.keymap.set("n", "<localleader><localleader>e", ds.buffer.edit, { silent = false, desc = "edit file" })

-- prepare to call |ds.reload()| on the current lua file
vim.keymap.set("n", "<localleader><localleader>r", function()
  if vim.bo.filetype ~= "lua" then
    ds.warn "Reload utility only available for lua modules"
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  local mod = ds.get_module(file)
  local shift = ""
  if #mod == 0 then shift = "<left><left>" end
  return ([[:lua ds.reload("%s")%s]]):format(mod, shift)
end, { silent = false, expr = true, replace_keycodes = true, desc = "reload current lua module" })

-- save as new file within the current directory (with the option to delete the original)
vim.keymap.set("n", "<localleader><localleader>s", ds.buffer.rename, { silent = false, desc = "rename file" })

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

-- delete the current buffer
vim.keymap.set("n", "<bs>z", ds.buffer.delete, { silent = false, desc = "delete current buffer" })

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
  local lines = ds.buffer.get_visual_selection()
  local selection = table.concat(lines)
  return (":<c-u>%%s/%s/"):format(selection)
end, { silent = false, expr = true, replace_keycodes = true, desc = "replace occurences of selection" })

-- execute selected text (for vim/lua files)
vim.keymap.set("v", "<c-w><c-x>", function()
  local function eval_chunk(selection)
    local text = table.concat(selection, "\n")
    local eval_ok, eval_result
    local title
    local ok, expr = pcall(loadstring, "return " .. text)
    if ok and expr then
      title = "Execution Context (expr)"
      eval_ok, eval_result = pcall(expr)
      if not eval_ok then ds.error({ "Chunk executed:", text, "Result", eval_result }, { title = title }) end
      ds.info({ "Chunk executed:", text, "Result", eval_result or "<No output>" }, { title = title })
      return
    end
    local lines = vim.deepcopy(selection)
    lines[#lines] = "return " .. lines[#lines]
    ok, expr = pcall(loadstring, table.concat(lines, "\n"))
    if ok and expr then
      title = "Execution Context (block-expr)"
      eval_ok, eval_result = pcall(expr)
      if not eval_ok then ds.error({ "Chunk executed:", text, "Result", eval_result }, { title = title }) end
      ds.info({ "Chunk executed:", text, "Result", eval_result or "<No output>" }, { title = title })
      return
    end
    local errmsg
    ok, expr, errmsg = pcall(loadstring, text)
    if not ok then error(errmsg) end
    title = "Execution Context (block)"
    eval_ok, eval_result = pcall(expr)
    if not eval_ok then ds.error({ "Chunk executed:", text, "Result", eval_result }, { title = title }) end
    ds.info({ "Chunk executed:", text, "Result", eval_result or "<No output>" }, { title = title })
  end
  local lines = ds.buffer.get_visual_selection()
  local selection = table.concat(lines)
  local ft = vim.bo.filetype
  if ft == "vim" then
    local out = vim.api.nvim_exec2(([[%s]]):format(selection), true)
    vim.print(out)
  elseif ft == "lua" then
    eval_chunk(lines)
  end
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

-- preserve register after pasting text over selection
vim.keymap.set("x", "p", [["_dP]], { desc = "preserve register after pasting" })

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
  if vim.fn.pumvisible() then return "<c-p>" end
  return "<up>"
end, { silent = false, expr = true, replace_keycodes = true })

-- navigate completion menu using down key
vim.keymap.set("c", "<down>", function()
  if vim.fn.pumvisible() then return "<c-n>" end
  return "<down>"
end, { silent = false, expr = true, replace_keycodes = true })

-- exit command mode
vim.keymap.set("c", "jk", "<c-c>", { desc = "leave command-line mode" })

-- populate command line with filepath to parent directory of current buffer
vim.keymap.set("c", "%h", function() return vim.fs.dirname(vim.api.nvim_buf_get_name(0)) .. "/" end, {
  silent = false,
  expr = true,
  replace_keycodes = true,
  desc = "insert path to parent directory",
})

-- populate command line with filname of current buffer
vim.keymap.set("c", "%f", function() return vim.fs.basename(vim.api.nvim_buf_get_name(0)) end, {
  silent = false,
  expr = true,
  replace_keycodes = true,
  desc = "insert filename",
})

-- populate command line with filepath of current buffer
vim.keymap.set("c", "%p", function() return vim.fs.normalize(vim.api.nvim_buf_get_name(0)) end, {
  silent = false,
  expr = true,
  replace_keycodes = true,
  desc = "insert filepath",
})

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
