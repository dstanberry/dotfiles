---------------------------------------------------------------
-- => nvim-web-devicons configuration
---------------------------------------------------------------
-- verify nvim-web-devicons is available
if not pcall(require, 'nvim-web-devicons') then
  return
end

require('nvim-web-devicons').setup {
  override = {vimrc = {icon = "", color = "#019833", name = "Vimrc"}}
}
