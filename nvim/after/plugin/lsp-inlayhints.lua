-- verify lsp-inlayhints is available
local ok, hints = pcall(require, "lsp-inlayhints")
if not ok then
  return
end

vim.api.nvim_create_augroup("lsp_type_hints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp_type_hints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    hints.on_attach(client, bufnr)
  end,
})

hints.setup {
  inlay_hints = {
    parameter_hints = {
      show = false,
      prefix = "",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = true,
    },
    type_hints = {
      show = true,
      prefix = "",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = false,
    },
    only_current_line = false,
    labels_separator = "  ",
    max_len_align = false,
    max_len_align_padding = 1,
    highlight = "NonText",
  },
  enabled_at_startup = true,
  debug_mode = false,
}
