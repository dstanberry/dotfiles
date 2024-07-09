local M = {}

M.config = {
  cmd = { "omnisharp", ds.plugin.get_pkg_path("omnisharp", "libexec/OmniSharp.dll") },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
  handlers = {
    ["textDocument/definition"] = function(...) return require("omnisharp_extended").handler(...) end,
    ["textDocument/typeDefinition"] = function(...) return require("omnisharp_extended").handler(...) end,
    ["textDocument/references"] = function(...) return require("omnisharp_extended").references_handler(...) end,
    ["textDocument/implementation"] = function(...) return require("omnisharp_extended").implementation_handler(...) end,
  },
}

return M
