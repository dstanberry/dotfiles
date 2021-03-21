---------------------------------------------------------------
-- => nvim-colorizer
---------------------------------------------------------------
-- verify nvim-colorizer is available
local has_colorizer, colorizer = pcall(require, 'nvim-autopairs')
if not has_colorizer then
  return
end

-- setup configuration.
colorizer.setup {
  '*';
  css = { rgb_fn = true; };
  html = { names = false; }
}
