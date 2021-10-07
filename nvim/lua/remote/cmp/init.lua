-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.setup {
  documentation = {
    border = "rounded",
  },
  snippet = {
    expand = function(args)
      local has_luasnip, luasnip = pcall(require, "luasnip")
      if has_luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  mapping = {
    ["<c-p>"] = cmp.mapping.select_prev_item(),
    ["<c-n>"] = cmp.mapping.select_next_item(),
    ["<c-d>"] = cmp.mapping.scroll_docs(-4),
    ["<c-f>"] = cmp.mapping.scroll_docs(4),
    ["<c-space>"] = cmp.mapping.complete(),
    ["<esc>"] = cmp.mapping.close(),
    ["<cr>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "luasnip" },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = ({
        Class = " (class)",
        Color = " (color)",
        Constant = " (constant)",
        Constructor = " (constructor)",
        Enum = " (enum)",
        EnumMember = " (enum member)",
        Event = " (event)",
        Field = " (field)",
        File = " (file)",
        Folder = " (folder)",
        Function = " (function)",
        Interface = " (interface)",
        Keyword = " (keyword)",
        Method = " (method)",
        Module = "{} (module)",
        Operator = " (operator)",
        Property = " (property)",
        Reference = " (reference)",
        Snippet = " (snippet)",
        Struct = " (struct)",
        Text = " (text)",
        TypeParameter = " (type parameter)",
        Unit = " (unit)",
        Value = " (unit)",
        Variable = " (variable)",
      })[vim_item.kind]
      return vim_item
    end,
  },
}
