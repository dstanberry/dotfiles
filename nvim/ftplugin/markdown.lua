local markdown = require "ft.markdown"

vim.opt_local.formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=]
vim.opt_local.iskeyword:append "-"
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "min:5,list:-1"
vim.opt_local.concealcursor = "n"
vim.opt_local.conceallevel = 2
vim.opt_local.spell = false
vim.opt_local.wrap = true
vim.opt_local.listchars:append "eol: "

local md_extmarks = vim.api.nvim_create_augroup("md_extmarks", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "ModeChanged" }, {
  group = md_extmarks,
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(args)
    vim.schedule(function()
      if package.loaded["nvim-treesitter"] and vim.api.nvim_get_mode().mode == "n" then
        vim.opt_local.conceallevel = 2
        markdown.set_extmarks(args.buf)
      end
    end)
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
  group = md_extmarks,
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(args)
    vim.schedule(function()
      vim.opt_local.conceallevel = 0
      markdown.disable_extmarks(args.buf, true)
    end)
  end,
})

if package.loaded["nvim-treesitter"] then
  local _adjacent = function() markdown.insert_adjacent_heading(vim.api.nvim_get_current_buf()) end
  local _inner = function() markdown.insert_inner_heading(vim.api.nvim_get_current_buf()) end
  local _outer = function() markdown.insert_outer_heading(vim.api.nvim_get_current_buf()) end

  vim.keymap.set("n", "<c-w><c-a>", _adjacent, { buffer = 0, desc = "insert adjacent heading" })
  vim.keymap.set("n", "<c-w><c-i>", _inner, { buffer = 0, desc = "insert inner heading" })
  vim.keymap.set("n", "<c-w><c-o>", _outer, { buffer = 0, desc = "insert outer heading" })
end

vim.keymap.set("i", "<s-cr>", markdown.insert_list_marker, { buffer = 0, desc = "insert list marker" })
vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = 0, desc = "insert checkbox" })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = 0, desc = "insert link" })

vim.keymap.set({ "n", "v" }, "<c-w><c-b>", markdown.toggle_bullet, { buffer = 0, desc = "toggle bullet" })
vim.keymap.set({ "n", "v" }, "<c-w><c-x>", markdown.toggle_checkbox, { buffer = 0, desc = "toggle checkbox" })

-- NOTE: Completion engine will handle this better
-- vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = 0, desc = "zk: insert link to note" })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = 0, desc = "zk: insert link to note" })
