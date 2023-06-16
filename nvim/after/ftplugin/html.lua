vim.opt_local.conceallevel = 2

local html_conceal_ns = vim.api.nvim_create_namespace "html_concealer"
local group = vim.api.nvim_create_augroup("html_ftplugin", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = group,
  pattern = "html",
  callback = function(event)
    local bufnr = event.buf or vim.api.nvim_get_current_buf()
    local language_tree = vim.treesitter.get_parser(bufnr, "html")
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()
    local query = vim.treesitter.query.parse(
      "html",
      [[
        ((attribute
            (attribute_name) @att_name (#eq? @att_name "class")
            (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
      ]]
    )

    for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_(), {}) do
      local start_row, start_col, end_row, end_col = captures[2]:range()
      vim.api.nvim_buf_set_extmark(bufnr, html_conceal_ns, start_row, start_col, {
        end_line = end_row,
        end_col = end_col,
        conceal = metadata[2].conceal,
      })
    end
  end,
})
