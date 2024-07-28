local M = {}

M.enabled = false

M.config = {
  cmd = { vim.fn.exepath "dotnet", ds.plugin.get_pkg_path("omnisharp", "libexec/OmniSharp.dll") },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      LoadProjectsOnDemand = nil,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      AnalyzeOpenDocumentsOnly = nil,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)

    local opts = {
      reuse_win = true,
      layout_strategy = "vertical",
      layout_config = { height = 40, prompt_position = "bottom" },
    }
    local ropts = {
      layout_strategy = "vertical",
      layout_config = { height = 40, prompt_position = "bottom" },
      path_display = { "shorten" },
    }

    local _definition = function() require("omnisharp_extended").telescope_lsp_definition(opts) end
    local _implementation = function() require("omnisharp_extended").telescope_lsp_implementation(opts) end
    local _references = function() require("omnisharp_extended").telescope_lsp_references(ropts) end
    local _type_definition = function() require("omnisharp_extended").telescope_lsp_type_definition(opts) end

    vim.keymap.set("n", "gd", _definition, { buffer = bufnr, desc = "omnisharp: goto definition" })
    vim.keymap.set("n", "gi", _implementation, { buffer = bufnr, desc = "omnisharp: goto implementation" })
    vim.keymap.set("n", "gr", _references, { buffer = bufnr, desc = "omnisharp: show references" })
    vim.keymap.set("n", "gt", _type_definition, { buffer = bufnr, desc = "omnisharp: goto type definition" })

    local _unused = function()
      if not (client and bufnr) then return end
      local params = vim.lsp.util.make_position_params(0, "utf-8")
      local request = {
        Column = params.position.character,
        Line = params.position.line,
        FileName = vim.uri_to_fname(params.textDocument.uri),
        WantsTextChanges = true,
        ApplyTextChanges = false,
      }
      local response = client.request_sync("o#/fixusings", request, 500, bufnr)
      if response.err then
        ds.error(
          "`fixusings` failed:\n" .. response.err.data.message .. "\n" .. response.err.data.stack,
          { title = "Lsp: omnisharp", lang = "markdown", merge = true }
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

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (.NET)" })
    vim.keymap.set("n", "<leader>lu", _unused, { buffer = bufnr, desc = "typescript: remove unused imports" })
  end,
}

return M
