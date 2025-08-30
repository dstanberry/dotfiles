---@class remote.lsp.config
local M = {}

M.config = {
  on_new_config = function(new_config)
    local project_root =
      vim.fs.joinpath(ds.root.detectors.pattern(0, { "node_modules" })[1] or vim.uv.cwd(), "node_modules")
    local ng_path = ds.plugin.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server")
    local ts_dirs = vim.iter({ ng_path, project_root }):join ","
    local ng_dirs = vim
      .iter({ ng_path, project_root })
      :map(function(path) return vim.fs.joinpath(path, "@angular/language-service/node_modules") end)
      :join ","

    new_config.cmd =
      { vim.fn.exepath "ngserver", "--stdio", "--tsProbeLocations", ts_dirs, "--ngProbeLocations", ng_dirs }
  end,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.renameProvider = false

    require("remote.lsp.handlers").on_attach(client, bufnr)

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
}

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.component.html", "*.container.html" },
    callback = function() vim.treesitter.start(nil, "angular") end,
  })
end

return M
