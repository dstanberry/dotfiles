---------------------------------------------------------------
-- => nvim-compe configuration
---------------------------------------------------------------
-- verify nvim-compe is available
local has_compe, compe = pcall(require, "compe")
if not has_compe then
  return
end

compe.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 2,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = "rounded",
  },
  source = {
    -- builtin
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
    path = true,
    -- external
    luasnip = true,
    treesitter = true,
  },
}
