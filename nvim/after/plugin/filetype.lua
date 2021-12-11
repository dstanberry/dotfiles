-- verify filetype is available
local ok, filetype = pcall(require, "filetype")
if not ok then
  return
end

filetype.setup {
  overrides = {
    extensions = {
      asc = "text",
      gpg = "text",
      pgp = "text",
      scm = "query",
      vifm = "vim",
      vifmrc = "vim",
    },
    literal = {
      dircolors = "sh",
    },
    complex = {
      ["tmux.conf"] = "tmux",
    },
  },
}
