local util = require "util"

local cnoremap = util.map.cnoremap
local inoremap = util.map.inoremap
local nnoremap = util.map.nnoremap
local vnoremap = util.map.vnoremap
local xnoremap = util.map.xnoremap

local nmap = util.map.nmap
local vmap = util.map.vmap

---------------------------------------------------------------
-- => Normal
---------------------------------------------------------------
-- (spacefn) scroll current buffer
nnoremap("<up>", "<c-y>")
nnoremap("<down>", "<c-e>")

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
    if vim.g.LoupeLoaded == 1 then
      vim.fn["loupe#private#clear_highlight"]()
    end
    return util.map.t "<cmd>nohl<cr>"
  else
    return util.map.t "<cr>"
  end
end, {
  expr = true,
})

-- navigate quickfix list
nnoremap("<c-up>", "<cmd>cprevious<cr>zz")
nnoremap("<c-down>", "<cmd>cnext<cr>zz")

-- navigate location list
nnoremap("<a-up>", "<cmd>lprevious<cr>zz")
nnoremap("<a-down>", "<cmd>lnext<cr>zz")

-- find all occurences in buffer of word under cursor
nnoremap("<c-w><c-f>", [[/\v<c-r><c-w><cr>]], { silent = false })

-- begin substitution in buffer for word under cursor
nnoremap("<c-w><c-r>", [[:%s/\<<c-r><c-w>\>/]], { silent = false })

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

-- change text and preserve clipboard state
nmap("<leader>c", '"_c', { silent = false })
nmap("<leader>C", '"_C', { silent = false })

-- delete text and preserve clipboard state
nmap("<leader>d", '"_d', { silent = false })
nmap("<leader>D", '"_D', { silent = false })

-- shift current line down
nnoremap("<leader>j", ":m .+1<cr>==")
-- shift current line up
nnoremap("<leader>k", ":m .-2<cr>==")

-- save current buffer to disk and execute the file
nnoremap("<leader>x", function()
  local ft = vim.bo.filetype
  print(vim.cmd "write")
  if ft == "vim" then
    print(vim.cmd "source %")
  elseif ft == "lua" then
    print(vim.cmd "luafile %")
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
  return util.map.t((":edit %s/"):format(path))
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
  return util.map.t((":saveas %s/"):format(path))
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
-- insert newline above current line
inoremap("<c-enter>", "<c-o>O")
-- insert newline below current line
inoremap("<a-enter>", "<c-o>o")

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
-- begin substitution in buffer for visual selection
vnoremap("<c-w><c-r>", function()
  local selection = util.buffer.get_visual_selection()
  return util.map.t((":<c-u>%%s/%s/"):format(selection))
end, {
  silent = false,
  expr = true,
})

-- execute selected text
vnoremap("<leader>x", function()
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
  local ok, cmp = pcall(require, "cmp")
  local visible = false
  if ok then
    visible = cmp.visible()
  end
  if vim.fn.pumvisible() == 1 or visible then
    return util.map.t "<c-p>"
  else
    return util.map.t "<up>"
  end
end, {
  silent = false,
  expr = true,
})
cnoremap("<down>", function()
  local ok, cmp = pcall(require, "cmp")
  local visible = false
  if ok then
    visible = cmp.visible()
  end
  if vim.fn.pumvisible() == 1 or visible then
    return util.map.t "<c-n>"
  else
    return util.map.t "<down>"
  end
end, {
  silent = false,
  expr = true,
})

-- exit command mode
cnoremap("jk", "<c-c>")

-- populate command line with path to file of current buffer
cnoremap("%H", function()
  return util.map.t(vim.fn.expand "%:p:h" .. "/")
end, {
  silent = false,
  expr = true,
})
-- populate command line with file name of current buffer
cnoremap("%T", function()
  return util.map.t(vim.fn.expand "%:t")
end, {
  silent = false,
  expr = true,
})
-- populate command line with path to parent dir of current buffer
cnoremap("%P", function()
  return util.map.t(vim.fn.expand "%:p")
end, {
  silent = false,
  expr = true,
})
