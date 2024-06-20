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

return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "grapp-dev/nui-components.nvim",
    dependecies = {
      "windwp/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = { open_cmd = "noswapfile vnew" },
    },
    keys = {
      {
        "<localleader>sr",
        function() require("remote.nui.pickers.spectre").toggle() end,
        desc = "spectre: replace in files",
      },
    },
  },
}
