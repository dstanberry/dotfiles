local M = {}

M.config = {
  on_attach = function(client, bufnr)
    require("remote.lsp.handlers").on_attach(client, bufnr)
    local _crate = function()
      if vim.fn.expand "%:t" ~= "Cargo.toml" then return end
      if require("crates").popup_available() then require("crates").show_popup() end
    end
    vim.keymap.set("n", "gk", _crate, { buffer = bufnr, desc = "taplo: show references" })
  end,
}

return M
