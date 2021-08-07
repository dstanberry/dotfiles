local map = require "util.map"

local cnoremap = map.cnoremap
local inoremap = map.inoremap
local nnoremap = map.nnoremap
local vnoremap = map.vnoremap
local xnoremap = map.xnoremap

local vmap = map.vmap

---------------------------------------------------------------
-- => Normal
---------------------------------------------------------------
-- (spacefn) navigate quickfix list
nnoremap("<up>", "<cmd>cprevious<cr>zz")
nnoremap("<down>", "<cmd>cnext<cr>zz")

-- switch to next buffer
nnoremap("<right>", "<cmd>bnext<cr>")
-- switch to previous buffer
nnoremap("<left>", "<cmd>bprevious<cr>")

-- switch to next tab
nnoremap("<tab>", "<cmd>tabnext<cr>")
-- switch to previous tab
nnoremap("<s-tab>", "<cmd>tabprevious<cr>")

-- clear hlsearch if set, otherwise send default behaviour
nnoremap("<cr>", function()
  if vim.v.hlsearch == 1 then
    return map.t "<cmd>nohl<cr>"
  else
    return map.t "<cr>"
  end
end, {
  expr = true,
})

-- navigate loclist list
nnoremap("<a-k>", "<cmd>lprevious<cr>zz")
nnoremap("<a-j>", "<cmd>lnext<cr>zz")

-- find all occurences in buffer of word under cursor
nnoremap("<c-f>f", "/\\v<c-r><c-w><cr>", { silent = false })

-- begin substitution in buffer for word under cursor
nnoremap("<c-f>r", ":%s/\\<<c-r><c-w>\\>/", { silent = false })

-- switch to left window
nnoremap("<c-h>", "<c-w><c-h>")
-- switch to bottom window
nnoremap("<c-j>", "<c-w><c-j>")
-- switch to top window
nnoremap("<c-k>", "<c-w><c-k>")
-- switch to right window
nnoremap("<c-l>", "<c-w><c-l>")

-- decrease active split horizontal size
nnoremap("<a-h>", "<c-w><")
-- increase active split horizontal size
nnoremap("<a-l>", "<c-w>>")
-- increase active split vertical size
nnoremap("<a-k>", "<c-w>+")
-- decrease active split vertical size
nnoremap("<a-j>", "<c-w>-")

-- enable very magic mode during search operations
nnoremap("/", "/\\v", { silent = false })

-- allow semi-colon to enter command mode
nnoremap(";", ":", { silent = false })

-- move to the beginning of the current line
nnoremap("H", "^")

-- keep cursor stationary when joining line(s) below
nnoremap("J", "mzJ`z")

-- move to the end of the current line
nnoremap("L", "g_")

-- keep screen centered when jumping between search matches
nnoremap("n", "nzz")
nnoremap("N", "Nzz")

-- insert newline without entering insert mode
nnoremap("o", "o<esc>")
nnoremap("O", "O<esc>")

-- disable recording to a register
nnoremap("q", "<nop>")

-- avoid unintentional switches to Ex mode.
nnoremap("Q", "<nop>")

-- yank to end of line
nnoremap("Y", "y$")

---------------------------------------------------------------
-- => Normal | Leader
---------------------------------------------------------------
-- (try to) make all windows the same size
nnoremap("<leader>=", "<c-w>=")

-- shift current line down
nnoremap("<leader>j", ":m .+1<cr>==")
-- shift current line up
nnoremap("<leader>k", ":m .-2<cr>==")

-- close the current window or close app if this is the last window
nnoremap("<leader>q", "<cmd>quit<cr>", { silent = false })
-- write current buffer to disk if changed
nnoremap("<leader>w", "<cmd>update<cr>", { silent = false })

-- save current buffer to disk and execute the file
nnoremap("<leader>x", function()
  local ft = vim.bo.filetype
  if ft == "vim" then
    print(vim.cmd [[silent! write | source %]])
  elseif ft == "lua" then
    print(vim.cmd [[silent! write | luafile %]])
  end
end, {
  silent = false,
})

-- close the current buffer
nnoremap("<leader>z", "<cmd>bdelete<cr>")

---------------------------------------------------------------
-- => Normal | Local Leader
---------------------------------------------------------------
-- populate command mode with last command
nnoremap("<localleader>c", ":<up>", { silent = false })

-- create/edit file within the current directory
nnoremap("<localleader>e", function()
  local path = vim.fn.expand "%:p:h"
  return map.t((":edit %s/"):format(path))
end, {
  silent = false,
  expr = true,
})

-- trim trailing whitespace
nnoremap("<localleader>ff", function()
  for ln, str in ipairs(vim.fn.getline(1, "$")) do
    local sub = str:match "(.*%S)" or str
    vim.fn.setline(ln, sub)
  end
end, {
  silent = false,
})

-- save as new file within the current directory
nnoremap("<localleader>s", function()
  local path = vim.fn.expand "%:p:h"
  return map.t((":saveas %s/"):format(path))
end, {
  silent = false,
  expr = true,
})

-- discard all file modifications and close instance
nnoremap("<localleader>qq", "ZQ")

-- execute current line
nnoremap("<localleader>x", function()
  local ft = vim.bo.filetype
  if ft == "vim" then
    print(vim.cmd [[execute getline(".")]])
  elseif ft == "lua" then
    print(vim.cmd(([[lua %s]]):format(vim.fn.getline ".")))
  end
end, {
  silent = false,
})

-- discard changes to current buffer and close it
nnoremap("<localleader>z", "<cmd>bdelete!<cr>", { silent = true })

---------------------------------------------------------------
-- => Insert
---------------------------------------------------------------
-- shift current line down
inoremap("<c-j>", "<esc>:m .+1<cr>==i")
-- shift current line up
inoremap("<c-k>", "<esc>:m .-2<cr>==i")

-- define undo break point
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("!", "!<c-g>u")
inoremap("?", "?<c-g>u")

-- exit insert mode
inoremap("jk", "<esc>")

---------------------------------------------------------------
-- => Visual
---------------------------------------------------------------
-- move between windows.
vnoremap("<c-h>", "<c-w>h")
vnoremap("<c-j>", "<c-w>j")
vnoremap("<c-k>", "<c-w>k")
vnoremap("<c-l>", "<c-w>l")

-- maintain selection after indentation
vmap("<", "<gv")
vmap(">", ">gv")

-- enable very magic mode during search operations
vnoremap("/", "/\\v", { silent = false })

-- allow semi-colon to enter command mode
vmap(";", ":", { silent = false })

-- move selection to the beginning of the current line
vnoremap("H", "^")
-- move selection to the end of the current line
vnoremap("L", "g_")

-- shift selected text down
xnoremap("J", ":move '>+<cr>gv=gv")
-- shift selected text up
xnoremap("K", ":move -2<cr>gv=gv")

---------------------------------------------------------------
-- => Visual | Leader
---------------------------------------------------------------
-- execute selected text
vnoremap("<leader>x", function()
  local function visual_selection_range()
    vim.cmd [[execute "normal! \<esc>"]]
    local csrow, cscol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local cerow, cecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
      return csrow, cscol, cerow, cecol
    else
      return cerow, cecol, csrow, cscol
    end
  end
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
  local csrow, _, cerow, _ = visual_selection_range()
  local lines = vim.fn.getline(csrow, cerow)
  local str = table.concat(lines, "\n")
  local ft = vim.bo.filetype
  local out = ""
  if ft == "vim" then
    out = vim.api.nvim_exec(([[%s]]):format(str), true)
  elseif ft == "lua" then
    out = eval_chunk(str)
  end
  print(out)
end, {
  silent = true,
})

---------------------------------------------------------------
-- => Command
---------------------------------------------------------------
-- move to the beginning of the command
cnoremap("<c-a>", "<Home>")
-- move to the end of the command
cnoremap("<c-e>", "<End>")

-- navigate completion menu using up/down keys
cnoremap("<up>", function()
  if vim.fn.pumvisible() ~= 0 then
    return map.t "<c-p>"
  else
    return map.t "<up>"
  end
end, {
  silent = false,
  expr = true,
})
cnoremap("<down>", function()
  if vim.fn.pumvisible() ~= 0 then
    return map.t "<c-n>"
  else
    return map.t "<down>"
  end
end, {
  silent = false,
  expr = true,
})

-- exit command mode
cnoremap("jk", "<c-c>")

-- populate command line with path to file of current buffer
cnoremap("%H", function()
  return map.t(vim.fn.expand "%:p:h" .. "/")
end, {
  silent = false,
  expr = true,
})

-- populate command line with file name of current buffer
cnoremap("%T", function()
  return map.t(vim.fn.expand "%:t")
end, {
  silent = false,
  expr = true,
})

-- populate command line with path to parent dir of current buffer
cnoremap("%P", function()
  return map.t(vim.fn.expand "%:p")
end, {
  silent = false,
  expr = true,
})
