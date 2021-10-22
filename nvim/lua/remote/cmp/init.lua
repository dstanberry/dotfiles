-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.setup {
  documentation = true,
  snippet = {
    expand = function(args)
      pcall(function()
        require("luasnip").lsp_expand(args.body)
      end)
    end,
  },
  mapping = {
    ["<c-d>"] = cmp.mapping.scroll_docs(-4),
    ["<c-f>"] = cmp.mapping.scroll_docs(4),
    ["<c-space>"] = cmp.mapping.complete(),
    ["<esc>"] = cmp.mapping.close(),
    ["<cr>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer", keyword_length = 5, max_item_count = 5 },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = ({
        Class = "פּ (class)",
        Color = " (color)",
        Constant = " (constant)",
        Constructor = " (constructor)",
        Enum = " (enum)",
        EnumMember = " (enum member)",
        Event = " (event)",
        Field = "陋 (field)",
        File = " (file)",
        Folder = " (folder)",
        Function = " (function)",
        Interface = " (interface)",
        Keyword = " (keyword)",
        Method = " (method)",
        Module = " (module)",
        Operator = " (operator)",
        Property = "襁 (property)",
        Reference = " (reference)",
        Snippet = " (snippet)",
        Struct = "פּ (struct)",
        Text = " (text)",
        TypeParameter = "т (type parameter)",
        Unit = " (unit)",
        Value = " (value)",
        Variable = "勞 (variable)",
      })[vim_item.kind]
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true,
  },
}
