---------------------------------------------------------------
-- => lsp completion menu item configuration
---------------------------------------------------------------
local kind_symbols = {
  Class = "פּ ",
  Color = " ",
  Constant = " ",
  Constructor = "襁",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = "陋 ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = "﯅ ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Operator = " ",
  Property =  " ",
  Reference = " ",
  Snippet = "賂",
  Struct = " ",
  Text = " ",
  TypeParameter = "т ",
  Unit = " ",
  Value = " ",
  Variable = "勞 ",
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

local function set_completion_symbols(opts)
  local with_text = opts == nil or opts["with_text"]
  local symbol_map = (opts and opts["symbol_map"] and vim.tbl_extend("force", kind_symbols, opts["symbol_map"]))
    or kind_symbols

  local symbols = {}
  local len = 25
  if with_text == true or with_text == nil then
    for i = 1, len do
      local name = kind_order[i]
      local symbol = symbol_map[name]
      symbol = symbol and (symbol .. " ") or ""
      symbols[i] = string.format("%s%s", symbol, name)
    end
  else
    for i = 1, len do
      local name = kind_order[i]
      symbols[i] = symbol_map[name]
    end
  end

  require("vim.lsp.protocol").CompletionItemKind = symbols
end

set_completion_symbols(kind_symbols)
