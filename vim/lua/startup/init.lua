---------------------------------------------------------------
-- => Helper Functions
---------------------------------------------------------------
-- print inspection of variable
P = function(v)
  print(vim.inspect(v))
  return v
end

-- enable live-reloading of lua functions
if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

---------------------------------------------------------------
-- => Plugins
---------------------------------------------------------------
require('startup.plugin').source()
