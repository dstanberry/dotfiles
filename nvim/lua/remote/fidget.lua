return {
  "j-hui/fidget.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    text = {
      spinner = "dots_pulse",
    },
    align = {
      bottom = true,
      right = true,
    },
  },
  init = function()
    vim.api.nvim_create_augroup("fidget", { clear = true })
    vim.api.nvim_create_autocmd({ "VimLeavePre", "LspDetach" }, {
      group = "fidget",
      callback = function()
        vim.cmd { cmd = "FidgetClose", mods = { emsg_silent = true, confirm = true } }
      end,
    })
  end,
}
