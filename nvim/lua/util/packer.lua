---------------------------------------------------------------
-- => Packer Helper Functions
---------------------------------------------------------------
-- initialize modules table
local M = {}

-- install packer.nvim
function M.bootstrap()
  if vim.fn.input "Download Packer? (y for yes)" ~= "y" then
    return
  end
  local directory = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data")
  vim.fn.mkdir(directory, "p")
  local out = vim.fn.system(
    string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", directory .. "/packer.nvim")
  )
  M.info(out)
  M.info "Downloading packer.nvim..."
  M.info "( Restart is required! )"
end

return M
