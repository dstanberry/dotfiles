return {
  "tamago324/lir.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "tamago324/lir-git-status.nvim",
    "tamago324/lir-mmv.nvim",
  },
  keys = {
    -- stylua: ignore
    { "-", function() vim.cmd.edit(vim.fn.expand "%:h") end, },
  },
  config = function()
    local actions = require "lir.actions"
    local git_status = require "lir.git_status"
    local has_mmv, mmv_actions = pcall(require "lir.mmv.actions")
    require("lir").setup {
      devicons = {
        enable = true,
        highlight_dirname = true,
      },
      hide_cursor = true,
      show_hidden_files = false,
      mappings = {
        ["."] = actions.toggle_show_hidden,
        [".."] = actions.up,
        ["<c-t>"] = actions.tabedit,
        ["<c-v>"] = actions.vsplit,
        ["<c-x>"] = actions.split,
        ["<cr>"] = actions.edit,
        ["dd"] = actions.delete,
        ["M"] = actions.mkdir,
        ["N"] = actions.newfile,
        ["R"] = has_mmv and mmv_actions.mmv or nil,
        ["r"] = actions.rename,
        ["Y"] = actions.yank_path,
      },
    }
    git_status.setup { show_ignored = true }
  end,
}
