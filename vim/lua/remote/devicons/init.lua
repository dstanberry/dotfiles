---------------------------------------------------------------
-- => nvim-web-devicons configuration
---------------------------------------------------------------
-- verify nvim-web-devicons is available
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
if not has_devicons then
  return
end

-- define custom icons based on filetype
devicons.setup {
  override = {
    ["_dir_"] = {icon = "", color = "#6f8fb4", name = "Dir"},
    [".tmux"] = {icon = "", color = "#4d5a5e", name = "Shellscript"},
    ["bashrc"] = {icon = "", color = "#89e051", name = "Bashrc"},
    ["config"] = {icon = "", color = "#f14c28", name = "GitConfig"},
    ["dircolors"] = {icon = "", color = "#4d5a5e", name = "Shellscript"},
    ["diff-highlight"] = {icon = "", color = "#3f416a", name = "Perl"},
    ["gitconfig"] = {icon = "", color = "#f14c28", name = "GitConfig"},
    ["ignore"] = {icon = "", color = "#41535b", name = "GitIgnore"},
    ["menos"] = {icon = "", color = "#cc402f", name = "Ruby"},
    ["tmTheme"] = {icon = "謹", color = "#e37933", name = "Xml"},
    ["vimrc"] = {icon = "", color = "#019833", name = "Vimrc"},
    ["worktrees"] = {icon = "", color = "#41535b", name = "GitDir"},
    ["zshrc"] = {icon = "", color = "#89e051", name = "Zshrc"}
  }
}

-- helper function to get corresponding icon for filetype
function GetDevIcon(path, ext)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = ext or vim.fn.fnamemodify(path, ':e')
  return devicons.get_icon(filename, extension, {default = true})
end
