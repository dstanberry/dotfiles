return {
  "akinsho/toggleterm.nvim",
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
  },
  init = function()
    -- TODO: figure out how to deduplicate this 
    if has "win32" then
      vim.o.shell = "pwsh"
      vim.o.shellcmdflag = table.concat({
        "-NoLogo",
        "-ExecutionPolicy RemoteSigned",
        "-Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
      }, " ")
      vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
      vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
      vim.o.shellquote = ""
      vim.o.shellxquote = ""
    end

    local Terminal = require("toggleterm.terminal").Terminal
    local float
    float = Terminal:new {
      direction = "float",
      on_open = function(term)
        vim.keymap.set(
          { "i", "n", "t" },
          "<a-t>",
          function() float:toggle() end,
          { buffer = term.bufnr, desc = "toggleterm: toggle float" }
        )
      end,
    }
    vim.keymap.set({ "i", "n" }, "<a-t>", function() float:toggle() end, { desc = "toggleterm: toggle float" })

    local tab
    tab = Terminal:new {
      direction = "tab",
      on_open = function(term)
        vim.keymap.set(
          { "i", "n", "t" },
          "<a-y>",
          function() tab:toggle() end,
          { buffer = term.bufnr, desc = "toggleterm: toggle tab" }
        )
      end,
    }
    vim.keymap.set({ "i", "n" }, "<a-y>", function() tab:toggle() end, { desc = "toggleterm: toggle tab" })
  end,
}
