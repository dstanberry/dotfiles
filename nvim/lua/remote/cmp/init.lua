-- verify nvim-cmp is available
local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

local util = require "util"

cmp.setup {
  documentation = false,
  snippet = {
    expand = function(args)
      pcall(function()
        require("luasnip").lsp_expand(args.body)
      end)
    end,
  },
  mapping = {
    ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
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
    { name = "buffer", priority = 1, keyword_length = 5, max_item_count = 5 },
    { name = "nvim_lsp", priority = 10 },
    { name = "path", priority = 5 },
    { name = "luasnip", priority = 15 },
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
        Function = " (function)",
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

util.define_augroup {
  name = "cmp_lua",
  clear = true,
  autocmds = {
    {
      event = "FileType",
      pattern = "lua",
      callback = function()
        require("cmp").setup.buffer {
          sources = {
            { name = "buffer", priority = 1, keyword_length = 5, max_item_count = 5 },
            { name = "luasnip", priority = 15 },
            { name = "nvim_lsp", priority = 10 },
            { name = "nvim_lua", priority = 10 },
            { name = "path", priority = 5 },
          },
        }
      end,
    },
  },
}
