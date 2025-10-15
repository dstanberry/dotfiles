if vim.g.vscode then return end

local buf = vim.api.nvim_get_current_buf()
local map = vim.keymap.set

local _show_preview = function() ds.ft.markdown.preview(buf) end
local _stop_preview = function() ds.ft.markdown.preview.stop(buf) end

map("n", "<leader>mp", _show_preview, { buffer = buf, desc = "markdown: preview document" })
map("n", "<leader>ms", _stop_preview, { buffer = buf, desc = "markdown: stop preview of document" })

if package.loaded["nvim-treesitter"] then
  local _adjacent = function() ds.ft.markdown.insert_adjacent_heading(buf) end
  local _inner = function() ds.ft.markdown.insert_inner_heading(buf) end
  local _outer = function() ds.ft.markdown.insert_outer_heading(buf) end

  map("n", "<localleader>ia", _adjacent, { buffer = buf, desc = "markdown: insert adjacent heading" })
  map("n", "<localleader>ii", _inner, { buffer = buf, desc = "markdown: insert inner heading" })
  map("n", "<localleader>io", _outer, { buffer = buf, desc = "markdown: insert outer heading" })
end

map("i", "<s-cr>", ds.ft.markdown.insert_list_marker, { buffer = buf, desc = "markdown: insert list marker" })
map("i", "<c-w><c-c>", ds.ft.markdown.insert_checkbox, { buffer = buf, desc = "markdown: insert checkbox" })
map("i", "<c-w><c-l>", ds.ft.markdown.insert_link, { buffer = buf, desc = "markdown: insert link" })

map({ "n", "v" }, "<localleader>ib", ds.ft.markdown.toggle_bullet, { buffer = buf, desc = "markdown: toggle bullet" })
-- stylua: ignore
map({ "n", "v" }, "<localleader>ic", ds.ft.markdown.toggle_checkbox, { buffer = buf, desc = "markdown: toggle checkbox" })

if not ds.has "win32" then
  -- NOTE: Completion engine will handle this better
  -- map("i", "[[", markdown.zk.insert_link, { buffer = bufnr, desc = "zk: insert link to note" })
  map("v", "{{", ds.ft.markdown.zk.insert_link_from_selection, { buffer = buf, desc = "zk: insert link to note" })
end
