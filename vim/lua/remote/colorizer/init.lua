---------------------------------------------------------------
-- => nvim-colorizer
---------------------------------------------------------------
-- setup configuration.
require 'colorizer'.setup {
  '*';
  css = { rgb_fn = true; };
  html = { names = false; }
}
