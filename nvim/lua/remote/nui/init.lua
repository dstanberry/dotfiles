return {
  { "MunifTanjim/nui.nvim", lazy = true },
  { "windwp/nvim-spectre", lazy = true, opts = { open_cmd = "noswapfile vnew" } },
  {
    "grapp-dev/nui-components.nvim",
    keys = function()
      local _spectre = function() require("remote.nui.widgets.spectre").toggle() end
      return {
        { "<localleader>sr", _spectre, desc = "spectre: replace in files" },
      }
    end,
    init = function()
      ds.hl.new("NuiCursorLine", {})
      ds.hl.new("NuiLabel", { fg = vim.g.ds_colors.white })
      ds.hl.new("NuiNormalFloat", { fg = vim.g.ds_colors.white })
      ds.hl.new("NuiGapFloat", {})
      ds.hl.new("NuiResultsFloat", {})
      ds.hl.new("NuiFloatBorder", { fg = ds.color.blend(vim.g.ds_colors.gray1, vim.g.ds_colors.blue0, 0.44) })
      ds.hl.new("NuiComponentsButton", { link = "NormalSB" })
      ds.hl.new("NuiComponentsButtonActive", { link = "PMenuSel" })
      ds.hl.new("NuiComponentsCheckboxIcon", { fg = vim.g.ds_colors.fg0 })
      ds.hl.new("NuiComponentsCheckboxIconChecked", { fg = vim.g.ds_colors.magenta2, bold = true })
      ds.hl.new("NuiComponentsCheckboxLabel", { link = "NuiComponentsCheckboxIcon" })
      ds.hl.new("NuiComponentsCheckboxLabelChecked", { link = "NuiComponentsCheckboxIconChecked" })
    end,
  },
}
