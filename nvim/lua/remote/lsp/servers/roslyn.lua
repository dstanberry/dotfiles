---@class remote.lsp.config
local M = {}

M.config = {
  settings = {
    ["csharp|completion"] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ["csharp|highlighting"] = {
      dotnet_highlight_related_json_components = true,
      dotnet_highlight_related_regex_components = true,
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    navigation = {
      dotnet_navigate_to_decompiled_sources = true,
    },
  },
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)
    local _unused = function()
      if not (client and bufnr) then return end
      local request = {
        kind = "quickfix",
        data = {
          CustomTags = { "RemoveUnnecessaryImports" },
          TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
          CodeActionPath = { "Remove unnecessary usings" },
          Range = { ["start"] = { line = 0, character = 0 }, ["end"] = { line = 0, character = 0 } },
          UniqueIdentifier = "Remove unnecessary usings",
        },
      }
      local response = client:request_sync("codeAction/resolve", request, 1500, bufnr)
      if not response then
        ds.error("`fixusings` failed: no response from server", { title = "Lsp: roslyn", ft = "markdown" })
        return
      end
      ds.info { response }
      if response.err then
        ds.error(
          "`fixusings` failed:\n" .. response.err.data.message .. "\n" .. response.err.data.stack,
          { title = "Lsp: roslyn", ft = "markdown" }
        )
      elseif response.result.Changes then
        local edits = {}
        for _, change in pairs(response.result.Changes) do
          table.insert(edits, {
            newText = change.NewText,
            range = {
              start = {
                line = change.StartLine,
                character = change.StartColumn,
              },
              ["end"] = {
                line = change.EndLine,
                character = change.EndColumn,
              },
            },
          })
        end
        vim.lsp.util.apply_text_edits(edits, bufnr, "utf-8")
      end
    end

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (csharp)" })
    vim.keymap.set("n", "<leader>lu", _unused, { buffer = bufnr, desc = "typescript: remove unused imports" })
  end,
}

M.defer_setup = true

M.setup = function(opts)
  vim.api.nvim_create_autocmd("BufReadPre", {
    group = ds.augroup "lsp_roslyn",
    pattern = "*.cs",
    once = true,
    callback = function()
      require("roslyn").setup {
        config = vim.tbl_deep_extend("force", opts or {}, {
          cmd = { vim.fn.exepath "roslyn-language-server" },
        }),
      }
    end,
  })
end

return M
