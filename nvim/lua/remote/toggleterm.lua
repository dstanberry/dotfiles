return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  opts = {
    direction = "float",
    size = function(term)
      if term.direction == "horizontal" then
        return 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.5
      end
    end,
    hide_numbers = true,
    autochdir = true,
    highlights = {
      Normal = { link = "Normal" },
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
    },
    float_opts = {
      border = "single",
      winblend = 0,
    },
    winbar = {
      enabled = false,
    },
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    close_on_exit = true,
    shell = has "win32" and "pwsh -NoLogo" or vim.o.shell,
  },
  init = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float
    float = Terminal:new {
      direction = "float",
      on_open = function(term)
        vim.wo.sidescrolloff = 0
        vim.keymap.set(
          { "i", "n", "t" },
          "<a-w><a-t>",
          function() float:toggle() end,
          { buffer = term.bufnr, desc = "toggleterm: toggle float" }
        )
      end,
    }
    vim.keymap.set("n", "<a-w><a-t>", function() float:toggle() end, { desc = "toggleterm: toggle float" })

    local tab
    tab = Terminal:new {
      direction = "tab",
      on_open = function(term)
        vim.keymap.set(
          { "i", "n", "t" },
          "<a-w><a-y>",
          function() tab:toggle() end,
          { buffer = term.bufnr, desc = "toggleterm: toggle tab" }
        )
      end,
    }
    vim.keymap.set("n", "<a-w><a-y>", function() tab:toggle() end, { desc = "toggleterm: toggle tab" })

    local lazygit
    lazygit = Terminal:new {
      cmd = "lazygit",
      dir = "git_dir",
      hidden = true,
      direction = "tab",
      on_open = function(term)
        vim.wo.sidescrolloff = 0
        vim.keymap.set(
          { "i", "n", "t" },
          "<a-w><a-l>",
          function() lazygit:toggle() end,
          { buffer = term.bufnr, desc = "toggleterm: toggle float" }
        )
      end,
    }
    vim.keymap.set("n", "<a-w><a-l>", function() lazygit:toggle() end, { desc = "toggleterm: toggle lazygit" })
  end,
}
