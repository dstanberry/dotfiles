---@class remote.lsp.config
local M = {}

local get_cmd = function(root)
  local path = ds.plugin.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server")
  return {
    vim.fn.exepath "ngserver",
    "--stdio",
    "--tsProbeLocations",
    table.concat({ vim.fs.joinpath(path, "node_modules", "@angular", "language-service", "node_modules"), root }, ","),
    "--ngProbeLocations",
    table.concat({ vim.fs.joinpath(path, "node_modules", "@angular", "language-service", "node_modules"), root }, ","),
  }
end

local goto_template_or_component = function(bufnr)
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(bufnr, "angular/getTemplateLocationForComponent", params, function(_, result)
    if result then vim.lsp.util.show_document(result, "utf-8", { focus = true }) end
  end)
  vim.lsp.buf_request(bufnr, "angular/getComponentsWithTemplateFile", params, function(_, result)
    if result then
      if #result == 1 then
        vim.lsp.util.show_document(result[1], "utf-8", { focus = true })
      else
        vim.fn.setqflist({}, " ", { title = "Components", items = vim.lsp.util.locations_to_items(result, "utf-8") })
      end
    end
  end)
end

M.config = {
  on_new_config = function(new_config)
    local root_dir = ds.root.detectors.pattern(0, { "node_modules" })[1] or vim.uv.cwd()
    local node_modules = vim.fs.joinpath(root_dir, "node_modules")
    new_config.cmd = get_cmd(node_modules)
  end,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.renameProvider = false
    require("remote.lsp.handlers").on_attach(client, bufnr)
    vim.keymap.set(
      "n",
      "go",
      function() goto_template_or_component(bufnr) end,
      { buffer = bufnr, desc = "lsp: to component/template" }
    )
  end,
}

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.component.html", "*.container.html" },
    callback = function() vim.treesitter.start(nil, "angular") end,
  })
end

return M
