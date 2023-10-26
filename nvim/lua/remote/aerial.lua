local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("AerialArrayIcon", { link = "@storageclass" })
groups.new("AerialBooleanIcon", { link = "@boolean" })
groups.new("AerialClassIcon", { link = "@class" })
groups.new("AerialConstantIcon", { link = "@constant" })
groups.new("AerialConstructorIcon", { link = "@constructor" })
groups.new("AerialEnumIcon", { link = "@lsp.type.enum" })
groups.new("AerialEnumMemberIcon", { link = "@lsp.type.enumMember" })
groups.new("AerialEventIcon", { link = "@lsp.type.event" })
groups.new("AerialFieldIcon", { link = "@field.yaml" })
groups.new("AerialFileIcon", { link = "Directory" })
groups.new("AerialFunctionIcon", { link = "@function" })
groups.new("AerialInterfaceIcon", { link = "@lsp.type.interface" })
groups.new("AerialKeyIcon", { link = "@field.yaml" })
groups.new("AerialKeywordIcon", { link = "@keyword" })
groups.new("AerialMethodIcon", { link = "@method" })
groups.new("AerialModuleIcon", { link = "@include" })
groups.new("AerialNamespaceIcon", { link = "@namespace" })
groups.new("AerialNullIcon", { link = "@error" })
groups.new("AerialNumberIcon", { link = "@number" })
groups.new("AerialObjectIcon", { link = "@type" })
groups.new("AerialOperatorIcon", { link = "@operator" })
groups.new("AerialPackageIcon", { link = "@include" })
groups.new("AerialPropertyIcon", { link = "@field.yaml" })
groups.new("AerialStringIcon", { link = "@string" })
groups.new("AerialStructIcon", { link = "@type" })
groups.new("AerialTypeParameterIcon", { link = "@type" })
groups.new("AerialVariableIcon", { link = "@field.yaml" })

groups.new("AerialNormal", { link = "WinbarContext" })
groups.new("AerialLine", { link = "CursorLine" })
groups.new("AerialSeparator", { fg = color.blend(c.purple1, c.bg2, 0.38) })

return {
  "stevearc/aerial.nvim",
  event = "LazyFile",
  keys = {
    { "<leader>as", function() vim.cmd "AerialToggle" end, desc = "aerial: toggle symbols" },
  },
  opts = {
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    show_guides = true,
    layout = {
      resize_to_content = true,
      win_opts = {
        winhl = "Normal:Winbar,FloatBorder:FloatBorderSB",
        signcolumn = "yes",
        statuscolumn = " ",
      },
    },
    icons = vim.tbl_extend(
      "keep",
      vim.tbl_map(function(kind) return pad(kind, "right") end, icons.kind),
      vim.tbl_map(function(kind) return pad(kind, "right") end, icons.type)
    ),
    guides = {
      mid_item = icons.misc.LightVerticalAndRight,
      last_item = icons.misc.LightUpAndRight,
      nested_top = icons.misc.VerticalBarThin,
      whitespace = "  ",
    },
  },
  config = function(_, opts)
    require("aerial").setup(opts)

    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then return end

    local themes = require "telescope.themes"

    telescope.load_extension "aerial"
    vim.keymap.set(
      "n",
      "<leader>ag",
      function()
        telescope.extensions.aerial.aerial(themes.get_dropdown {
          previewer = false,
          prompt_title = "Aerial (Goto Symbol)",
        })
      end,
      { desc = "aerial: goto symbol" }
    )
  end,
}
