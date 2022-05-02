-- verify git-conflict is available
local ok, conflict = pcall(require, "git-conflict")
if not ok then
  return
end

conflict.setup {
  default_mappings = true,
  disable_diagnostics = false,
  highlights = {
    incoming = "DiffText",
    current = "DiffAdd",
  },
}
