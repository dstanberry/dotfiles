local markdown = require "ft.markdown"

local bufnr = vim.api.nvim_get_current_buf()

if package.loaded["nvim-treesitter"] then
  local _adjacent = function() markdown.insert_adjacent_heading(bufnr) end
  local _inner = function() markdown.insert_inner_heading(bufnr) end
  local _outer = function() markdown.insert_outer_heading(bufnr) end

  vim.keymap.set("n", "<localleader>ia", _adjacent, { buffer = bufnr, desc = "markdown: insert adjacent heading" })
  vim.keymap.set("n", "<localleader>ii", _inner, { buffer = bufnr, desc = "markdown: insert inner heading" })
  vim.keymap.set("n", "<localleader>io", _outer, { buffer = bufnr, desc = "markdown: insert outer heading" })
end

vim.keymap.set("i", "<s-cr>", markdown.insert_list_marker, { buffer = bufnr, desc = "markdown: insert list marker" })
vim.keymap.set("i", "<c-w><c-c>", markdown.insert_checkbox, { buffer = bufnr, desc = "markdown: insert checkbox" })
vim.keymap.set("i", "<c-w><c-l>", markdown.insert_link, { buffer = bufnr, desc = "markdown: insert link" })

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<localleader>ib", markdown.toggle_bullet, { buffer = bufnr, desc = "markdown: toggle bullet" })
vim.keymap.set({ "n", "v" }, "<localleader>ic", markdown.toggle_checkbox, { buffer = bufnr, desc = "markdown: toggle checkbox" })
-- stylua: ignore end

-- NOTE: Completion engine will handle this better
-- vim.keymap.set("i", "[[", markdown.zk.insert_link, { buffer = bufnr, desc = "zk: insert link to note" })
vim.keymap.set("v", "{{", markdown.zk.insert_link_from_selection, { buffer = bufnr, desc = "zk: insert link to note" })
