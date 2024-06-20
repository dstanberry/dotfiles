local node_modules = function(dirs)
  return ds.map(dirs, function(dir) return table.concat({ dir, "node_modules" }, "/") end)
end

local get_cmd = function(workspace_dir)
  local angularls_path = ds.lazy.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server")
  local cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    table.concat(node_modules { angularls_path, workspace_dir }, ","),
    "--ngProbeLocations",
    table.concat(
      node_modules {
        table.concat({ angularls_path, "node_modules", "@angular", "language-service" }, "/"),
        workspace_dir,
      },
      ","
    ),
  }
  if ds.has "win32" then
    local exec = vim.fn.exepath(cmd[1])
    cmd[1] = exec ~= "" and exec or "ngserver"
  end
  return cmd
end

local goto_template = function()
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(0, "angular/getTemplateLocationForComponent", params, function(_, result)
    if result then vim.lsp.util.jump_to_location(result, "utf-8") end
  end)
end

local goto_component = function()
  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request(0, "angular/getComponentsWithTemplateFile", params, function(_, result)
    if result then
      if #result == 1 then
        vim.lsp.util.jump_to_location(result[1], "utf-8")
      else
        vim.fn.setqflist({}, " ", {
          title = "Angular Component Files",
          items = vim.lsp.util.locations_to_items(result, "utf-8"),
        })
        vim.cmd.copen()
      end
    end
  end)
end

local M = {}

M.config = {
  cmd = get_cmd(vim.uv.cwd()),
  on_new_config = function(new_config, root_dir) new_config.cmd = get_cmd(root_dir) end,
  on_attach = function(client)
    client.server_capabilities.renameProvider = false

    vim.api.nvim_create_user_command("NgTemplate", goto_template, {})
    vim.api.nvim_create_user_command("NgComponent", goto_component, {})
  end,
}

M.setup = function()
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.component.html", "*.container.html" },
    callback = function() vim.treesitter.start(nil, "angular") end,
  })
end

return M
