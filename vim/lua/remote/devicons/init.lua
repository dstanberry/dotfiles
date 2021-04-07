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
    vimrc = {icon = "", color = "#019833", name = "vimrc"},
    _dir_ = {icon = "", color = "#6f8fb4", name = "_dir_"}
  }
}

-- helper function to get corresponding icon for filetype
function GetDevIcon(path, ext)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = ext or vim.fn.fnamemodify(path, ':e')
  return devicons.get_icon(filename, extension, {default = true})
end
