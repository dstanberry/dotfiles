---------------------------------------------------------------
-- => completion.nvim
---------------------------------------------------------------
-- set completion confirm key
vim.g.completion_confirm_key = "<cr>"

-- set completion list priority
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- set trigger characters
vim.g.completion_trigger_keyword_length = 3

-- set snipping parser
vim.g.completion_enable_snippet = 'vim-vsnip'

vim.g.completion_chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    {complete_items = {'path'}, triggered_only = {'/'}},
    {complete_items = {'buffers'}},
  },
}
