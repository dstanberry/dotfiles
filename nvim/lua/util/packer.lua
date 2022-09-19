local M = {}

function M.bootstrap()
  local path = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data")
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.mkdir(path, "p")
    print "Installing packer.nvim..."
    local out = vim.fn.system(
      string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", path .. "/packer.nvim")
    )
    print(out)
    vim.cmd.packadd("packer.nvim")
  end
end

function M.setup(config, fn)
  M.bootstrap()
  local packer = require "packer"
  packer.init(config)
  return packer.startup {
    function(use)
      fn(use)
    end,
  }
end

return M
