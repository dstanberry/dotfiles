local util = require "util"

---------------------------------------------------------------
-- => Normal
---------------------------------------------------------------
-- (spacefn) scroll current buffer
vim.keymap.set("n", "<up>", "<c-y>")
vim.keymap.set("n", "<down>", "<c-e>")

-- switch to next buffer
vim.keymap.set("n", "<right>", "<cmd>bnext<cr>")
-- switch to previous buffer
vim.keymap.set("n", "<left>", "<cmd>bprevious<cr>")

-- switch to next tab
vim.keymap.set("n", "<tab>", "<cmd>tabnext<cr>")
-- switch to previous tab
vim.keymap.set("n", "<s-tab>", "<cmd>tabprevious<cr>")

-- clear hlsearch if set, otherwise send default behaviour
vim.keymap.set("n", "<cr>", function()
  return vim.v.hlsearch and "<cmd>nohl<cr>" or "<cr>"
end, { expr = true, replace_keycodes = true })

-- navigate quickfix list
vim.keymap.set("n", "<c-up>", "<cmd>cprevious<cr>zz")
vim.keymap.set("n", "<c-down>", "<cmd>cnext<cr>zz")

-- navigate location list
vim.keymap.set("n", "<a-up>", "<cmd>lprevious<cr>zz")
vim.keymap.set("n", "<a-down>", "<cmd>lnext<cr>zz")

-- find all occurences in buffer of word under cursor
vim.keymap.set("n", "<c-w><c-f>", [[/\v<c-r><c-w><cr>]], { silent = false })

-- begin substitution in buffer for word under cursor
vim.keymap.set("n", "<c-w><c-r>", [[:%s/\<<c-r><c-w>\>/]], { silent = false })

-- switch to left window
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")
-- switch to bottom window
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
-- switch to top window
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
-- switch to right window
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")

-- decrease active split horizontal size
vim.keymap.set("n", "<a-h>", "<c-w><")
-- increase active split horizontal size
vim.keymap.set("n", "<a-l>", "<c-w>>")
-- increase active split vertical size
vim.keymap.set("n", "<a-k>", "<c-w>+")
-- decrease active split vertical size
vim.keymap.set("n", "<a-j>", "<c-w>-")

-- allow semi-colon to enter command mode
vim.keymap.set("n", ";", ":", { silent = false })

-- move to the beginning of the current line
vim.keymap.set("n", "H", "^")

-- keep cursor stationary when joining line(s) below
vim.keymap.set("n", "J", "mzJ`z")

-- move to the end of the current line
vim.keymap.set("n", "L", "g_")

-- keep screen centered when jumping between search matches
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- insert newline without entering insert mode
vim.keymap.set("n", "o", "o<esc>")
vim.keymap.set("n", "O", "O<esc>")

-- disable recording to a register
vim.keymap.set("n", "q", "<nop>")

-- avoid unintentional switches to Ex mode.
vim.keymap.set("n", "Q", "<nop>")

-- yank to end of line
vim.keymap.set("n", "Y", "y$")

---------------------------------------------------------------
-- => Normal | Leader
---------------------------------------------------------------
-- (try to) make all windows the same size
vim.keymap.set("n", "<leader>=", "<c-w>=")

-- change text and preserve clipboard state
vim.keymap.set("n", "<leader>c", '"_c', { silent = false })
vim.keymap.set("n", "<leader>C", '"_C', { silent = false })

-- delete text and preserve clipboard state
vim.keymap.set("n", "<leader>d", '"_d', { silent = false })
vim.keymap.set("n", "<leader>D", '"_D', { silent = false })

-- shift current line down
vim.keymap.set("n", "<leader>j", ":m .+1<cr>==")
-- shift current line up
vim.keymap.set("n", "<leader>k", ":m .-2<cr>==")

-- prepare to call |reload()| on the current lua file
vim.keymap.set("n", "<leader>r", function()
  local ft = vim.bo.filetype
  if ft == "lua" then
    local file = (vim.fn.expand "%:p")
    local mod = util.get_module_name(file)
    local shift = ""
    if #mod == 0 then
      shift = "<left><left>"
    end
    return ([[:lua reload("%s")%s]]):format(mod, shift)
  end
end, { silent = false, expr = true, replace_keycodes = true })

-- save current buffer to disk and execute the file
vim.keymap.set("n", "<leader>x", function()
  local ft = vim.bo.filetype
  print(vim.cmd "write")
  if ft == "vim" then
    print(vim.cmd "source %")
  elseif ft == "lua" then
    print(vim.cmd "luafile %")
  end
end, { silent = false })

-- close the current buffer
vim.keymap.set("n", "<leader>z", function()
  util.buffer.delete_buffer(false)
end, { silent = false })

---------------------------------------------------------------
-- => Normal | Local Leader
---------------------------------------------------------------
-- prepare to run most recent ex-command
vim.keymap.set("n", "<localleader>c", ":<up>", { silent = false })

-- create/edit file within the current directory
vim.keymap.set("n", "<localleader>e", function()
  local path = vim.fn.expand "%:p:h"
  local separator = has "win32" and [[\]] or "/"
  return (":edit %s%s"):format(path, separator)
end, { silent = false, expr = true, replace_keycodes = true })

-- trim trailing whitespace
vim.keymap.set("n", "<localleader>ff", function()
  for ln, str in ipairs(vim.fn.getline(1, "$")) do
    local sub = str:match "(.*%S)" or str
    vim.fn.setline(ln, sub)
  end
end, { silent = false })

-- save as new file within the current directory (with the option to delete the original)
vim.keymap.set("n", "<localleader>s", function()
  local file = vim.fn.expand "%"
  local path = vim.fn.expand "%:p:h"
  local sep = has "win32" and [[\]] or "/"
  local updated = vim.fn.input("Save as: ", path .. sep)
  if #updated > 0 and updated ~= file then
    vim.cmd(("saveas %s"):format(updated))
    local move = vim.fn.input "Delete original file? (y/n): "
    if move == "y" or move == "yes" then
      vim.cmd(([[
        silent !rm %s
        bdelete %s
      ]]):format(file, file))
    end
  end
end, { silent = false })

-- discard all file modifications to current window
vim.keymap.set("n", "<localleader>qq", "ZQ")

-- discard all file modifications and close instance
vim.keymap.set("n", "<localleader>qa", "<cmd>qa!<cr>")

-- execute current line
vim.keymap.set("n", "<localleader>x", function()
  local ft = vim.bo.filetype
  if ft == "vim" then
    print(vim.cmd [[execute getline(".")]])
  elseif ft == "lua" then
    print(vim.cmd(([[lua %s]]):format(vim.fn.getline ".")))
  end
end, { silent = false })

-- discard changes to current buffer and close it
vim.keymap.set("n", "<localleader>z", function()
  util.buffer.delete_buffer(true)
end, { silent = false })

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
vim.keymap.set("v", "<c-h>", "<c-w>h")
vim.keymap.set("v", "<c-j>", "<c-w>j")
vim.keymap.set("v", "<c-k>", "<c-w>k")
vim.keymap.set("v", "<c-l>", "<c-w>l")

-- maintain selection after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- allow semi-colon to enter command mode
vim.keymap.set("v", ";", ":", { silent = false })

-- move selection to the beginning of the current line
vim.keymap.set("v", "H", "^")
-- move selection to the end of the current line
vim.keymap.set("v", "L", "g_")

-- shift selected text down
vim.keymap.set("x", "<c-down>", ":move '>+<cr>gv=gv")
-- shift selected text up
vim.keymap.set("x", "<c-up>", ":move -2<cr>gv=gv")

---------------------------------------------------------------
-- => Visual | Leader
---------------------------------------------------------------
-- begin substitution in buffer for visual selection
vim.keymap.set("v", "<c-w><c-r>", function()
  local selection = util.buffer.get_visual_selection()
  return (":<c-u>%%s/%s/"):format(selection)
end, { silent = false, expr = true, replace_keycodes = true })

-- execute selected text (for vim/lua files)
vim.keymap.set("v", "<leader>x", function()
  local function eval_chunk(str, ...)
    local chunk = loadstring(str, "@[evalrangeX]")
    local c = coroutine.create(chunk)
    local res = { coroutine.resume(c, ...) }
    if not res[1] then
      if debug.getinfo(c, 0, "f").func ~= chunk then
        res[2] = debug.traceback(c, res[2], 0)
      end
    end
    return unpack(res)
  end
  local selection = util.buffer.get_visual_selection()
  local ft = vim.bo.filetype
  local out = ""
  if ft == "vim" then
    out = vim.api.nvim_exec(([[%s]]):format(selection), true)
  elseif ft == "lua" then
    out = eval_chunk(selection)
  end
  print(out)
end, { silent = true })

---------------------------------------------------------------
-- => Command
---------------------------------------------------------------
-- move to the beginning of the command
vim.keymap.set("c", "<c-a>", "<home>", { silent = false })
-- move to the end of the command
vim.keymap.set("c", "<c-e>", "<end>", { silent = false })

-- navigate completion menu using up key
vim.keymap.set("c", "<up>", function()
  local ok, cmp = pcall(require, "cmp")
  local visible = false
  if ok then
    visible = cmp.visible()
  end
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
  if ok then
    visible = cmp.visible()
  end
  if vim.fn.pumvisible() == 1 or visible then
    return "<c-n>"
  else
    return "<down>"
  end
end, { silent = false, expr = true, replace_keycodes = true })

-- exit command mode
vim.keymap.set("c", "jk", "<c-c>")

-- populate command line with path to file of current buffer
vim.keymap.set("c", "%H", function()
  return vim.fn.expand "%:p:h" .. "/"
end, { silent = false, expr = true, replace_keycodes = true })

-- populate command line with file name of current buffer
vim.keymap.set("c", "%T", function()
  return vim.fn.expand "%:t"
end, { silent = false, expr = true, replace_keycodes = true })

-- populate command line with path to parent dir of current buffer
vim.keymap.set("c", "%P", function()
  return vim.fn.expand "%:p"
end, { silent = false, expr = true, replace_keycodes = true })

---------------------------------------------------------------
-- => Terminal
---------------------------------------------------------------
-- leave terminal mode
vim.keymap.set("t", "<esc><esc>", [[<c-\><c-n>]])

-- switch to left window
vim.keymap.set("t", "<c-h>", [[<c-\><c-n><c-w>h]])
-- switch to bottom window
vim.keymap.set("t", "<c-j>", [[<c-\><c-n><c-w>j]])
-- switch to toptwindow
vim.keymap.set("t", "<c-k>", [[<c-\><c-n><c-w>k]])
-- switch to rigtt window
vim.keymap.set("t", "<c-l>", [[<c-\><c-n><c-w>l]])

---------------------------------------------------------------
-- => Terminal | Leader
---------------------------------------------------------------
-- leave terminal mode
vim.keymap.set("t", "<leader><esc>", [[<c-\><c-n>]])
