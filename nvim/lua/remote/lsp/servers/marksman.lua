local M = {}

M.config = {
  root_dir = function(fname) return ds.root.detectors.pattern(fname, { ".marksman.toml", ".zk", ".git" })[1] end,
}

return M
