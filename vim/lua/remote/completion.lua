---------------------------------------------------------------
-- => completion.nvim
---------------------------------------------------------------
-- set completion confirm key
vim.g.completion_confirm_key = "<cr>"

-- set completion list priority
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- set trigger characters
vim.g.completion_trigger_keyword_length = 3

---------------------------------------------------------------
-- => complextras
---------------------------------------------------------------
-- set completion options
local has_compe, compe = pcall(require, 'compe')

if has_compe then
  compe.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    allow_prefix_unmatch = false;

    source = {
      path = true;
      buffer = true;
      calc = true;
      vsnip = true;
      nvim_lsp = true;
      nvim_lua = true;
      spell = true;
      tags = true;
      snippets_nvim = true;
    };
  }
end
