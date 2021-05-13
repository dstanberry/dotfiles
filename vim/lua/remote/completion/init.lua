---------------------------------------------------------------
-- => nvim-compe configuration
---------------------------------------------------------------
-- verify nvim-compe is available
local has_compe, compe = pcall(require, 'compe')
if not has_compe then
  return
end

compe.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 3,
  preselect = 'disable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true
  }
}

-- wrapper to ensure termcodes are sent correctly
local function replace_terms(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- show current buffer list
function _G.compe_confirm()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#confirm']()
  else
    return replace_terms("<cr>")
  end
end

function _G.compe_close()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#close']()
  else
    return replace_terms("<esc>")
  end
end
