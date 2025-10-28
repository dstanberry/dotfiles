---@class remote.lsp.config
local M = {}

M.config = {
  on_attach = function(client, bufnr)
    local _switch = function()
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

      vim.lsp.buf_request(bufnr, "angular/getTemplateLocationForComponent", params, function(_, result)
        if result then vim.lsp.util.show_document(result, client.offset_encoding, { focus = true }) end
      end)

      vim.lsp.buf_request(bufnr, "angular/getComponentsWithTemplateFile", params, function(_, result)
        if result then
          if #result == 1 then
            vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
          else
            vim.fn.setqflist(
              {},
              " ",
              { title = "Components", items = vim.lsp.util.locations_to_items(result, client.offset_encoding) }
            )
          end
        end
      end)
    end

    vim.keymap.set("n", "go", _switch, { buffer = bufnr, desc = "lsp: to component/template" })
  end,
  root_dir = function(bufnr, on_dir)
    local markers = vim.lsp.config["angularls"].root_markers
    local is_ng_project = vim.fs.root(bufnr, markers) ~= nil
    if is_ng_project then on_dir(vim.fs.root(bufnr, vim.lsp.config["angularls"].root_markers)) end
  end,
}

M.server_capabilities = {
  documentFormattingProvider = false,
  renameProvider = false,
}

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = ds.augroup "lsp.angularls",
    pattern = { "*.component.html", "*.container.html" },
    callback = function() vim.treesitter.start(nil, "angular") end,
  })
end

return function() return M end
