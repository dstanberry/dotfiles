return {
  on_attach = function(_, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fs.basename(fname):match "^%.env" then
      vim.schedule(function()
        local group = ds.augroup("remote.lsp.document_highlight", { clear = false })
        local autocommands =
          vim.api.nvim_get_autocmds { group = group, event = { "CursorHold", "CursorMoved" }, buffer = bufnr }

        ds.tbl_each(autocommands, function(v) vim.api.nvim_del_autocmd(v.id) end)
        vim.cmd "lsp stop bashls"
      end)
    end
  end,
}
