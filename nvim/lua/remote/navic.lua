local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NavicIconsArray", { fg = c.orange0 })
groups.new("NavicIconsBoolean", { fg = c.orange0 })
groups.new("NavicIconsClass", { fg = c.orange0 })
groups.new("NavicIconsConstant", { fg = c.magenta1 })
groups.new("NavicIconsConstructor", { fg = c.orange0 })
groups.new("NavicIconsEnum", { fg = c.orange0 })
groups.new("NavicIconsEnumMember", { fg = c.fg1 })
groups.new("NavicIconsEvent", { fg = c.orange0 })
groups.new("NavicIconsField", { fg = c.cyan1 })
groups.new("NavicIconsFile", { fg = c.fg1 })
groups.new("NavicIconsFunction", { fg = c.blue2 })
groups.new("NavicIconsInterface", { fg = c.orange0 })
groups.new("NavicIconsKey", { fg = c.purple0 })
groups.new("NavicIconsKeyword", { fg = c.purple0 })
groups.new("NavicIconsMethod", { fg = c.blue2 })
groups.new("NavicIconsModule", { fg = c.yellow2 })
groups.new("NavicIconsNamespace", { fg = c.fg1 })
groups.new("NavicIconsNull", { fg = c.orange0 })
groups.new("NavicIconsNumber", { fg = c.orange0 })
groups.new("NavicIconsObject", { fg = c.orange0 })
groups.new("NavicIconsOperator", { fg = c.fg1 })
groups.new("NavicIconsPackage", { fg = c.fg1 })
groups.new("NavicIconsProperty", { fg = c.fg1 })
groups.new("NavicIconsString", { fg = c.green2 })
groups.new("NavicIconsStruct", { fg = c.orange0 })
groups.new("NavicIconsTypeParameter", { fg = c.rose0 })
groups.new("NavicIconsVariable", { fg = c.magenta1 })

return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  opts = {
    depth_limit = 5,
    depth_limit_indicator = "..",
    highlight = true,
    icons = {
      Array = pad(icons.type.Array, "right"),
      Boolean = pad(icons.type.Boolean, "right"),
      Class = pad(icons.kind.Class, "right"),
      Constant = pad(icons.kind.Constant, "right"),
      Constructor = pad(icons.kind.Constructor, "right"),
      Enum = pad(icons.kind.Enum, "right"),
      EnumMember = pad(icons.kind.EnumMember, "right"),
      Event = pad(icons.kind.Event, "right"),
      Field = pad(icons.kind.Field, "right"),
      File = pad(icons.documents.File, "right"),
      Function = pad(icons.kind.Function, "right"),
      Interface = pad(icons.kind.Interface, "right"),
      Key = pad(icons.misc.Key, "right"),
      Method = pad(icons.kind.Function, "right"),
      Module = pad(icons.kind.Module, "right"),
      Namespace = pad(icons.kind.Class, "right"),
      Null = pad(icons.type.Boolean, "right"),
      Number = pad(icons.type.Number, "right"),
      Object = pad(icons.type.Object, "right"),
      Operator = pad(icons.kind.Operator, "right"),
      Package = pad(icons.type.Array, "right"),
      Property = pad(icons.kind.Property, "right"),
      String = pad(icons.type.String, "right"),
      Struct = pad(icons.kind.Struct, "right"),
      TypeParameter = pad(icons.kind.TypeParameter, "right"),
      Variable = pad(icons.kind.Variable, "right"),
    },
    separator = pad(icons.misc.ChevronRight, "both"),
  },
  init = function()
    vim.api.nvim_create_augroup("lsp_navic", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = "lsp_navic",
      callback = function(args)
        if vim.api.nvim_buf_line_count(0) > 1000 then vim.b.navic_lazy_update_context = true end
        if not (args.data and args.data.client_id) then return end

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, args.buf) end
      end,
    })
  end,
}
