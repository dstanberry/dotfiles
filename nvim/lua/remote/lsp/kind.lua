---------------------------------------------------------------
-- => lsp completion menu item configuration
---------------------------------------------------------------
local kind_symbols = {
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
}

local kind_order = {
  "Text",
  "Method",
  "Function",
  "Constructor",
  "Field",
  "File",
  "Variable",
  "Class",
  "Interface",
  "Module",
  "Property",
  "Unit",
  "Value",
  "Enum",
  "Keyword",
  "Snippet",
  "Color",
  "File",
  "Reference",
  "Folder",
  "EnumMember",
  "Constant",
  "Struct",
  "Event",
  "Operator",
  "TypeParameter",
}

local function set_completion_symbols()
  local with_text = false
  local symbols = {}
  local len = 25
  if with_text == true or with_text == nil then
    for i = 1, len do
      local name = kind_order[i]
      local symbol = kind_symbols[name]
      symbol = symbol and (symbol .. " ") or ""
      symbols[i] = string.format("%s%s", symbol, name)
    end
  else
    for i = 1, len do
      local name = kind_order[i]
      symbols[i] = kind_symbols[name]
    end
  end
  require("vim.lsp.protocol").CompletionItemKind = symbols
end

set_completion_symbols()
