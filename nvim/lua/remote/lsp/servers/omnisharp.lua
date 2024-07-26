local M = {}

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
  end,
}

return M
