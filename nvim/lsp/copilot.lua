---@class remote.lsp.config
local M = {}

local function sign_in(bufnr, client)
  client:request("signIn", vim.empty_dict(), function(error, result)
    if error then
      ds.warn(error.message, { title = "LSP: Copilot" })
      return
    end
    if result.command then
      local code = result.userCode
      local command = result.command
      vim.fn.setreg("+", code)
      vim.fn.setreg("*", code)
      local continue =
        vim.fn.confirm("Code copied to clipboard.\nOpen the browser to complete the sign-in process?", "&Yes\n&No")
      if continue == 1 then
        client:exec_cmd(command, { bufnr = bufnr }, function(err, res)
          if err then
            ds.warn(err.message, { title = "LSP: Copilot" })
            return
          end
          if res.status == "OK" then ds.info(("Signed in as ` %s `."):format(res.user)) end
        end)
      end
    end

    if result.status == "PromptUserDeviceFlow" then
      ds.info(("Enter your one-time code `%s` in %s"):format(result.userCode, result.verificationUri))
    elseif result.status == "AlreadySignedIn" then
      ds.info(("Already signed in as ` %s `."):format(result.user))
    end
  end)
end

---@param client vim.lsp.Client
local function sign_out(_, client)
  client:request("signOut", vim.empty_dict(), function(error, result)
    if error then
      ds.warn(error.message, { title = "LSP: Copilot" })
      return
    end
    if result.status == "NotSignedIn" then ds.info "Not signed in." end
  end)
end

M.config = {
  cmd = { "copilot-language-server", "--stdio" },
  init_options = {
    editorInfo = { name = "Neovim", version = tostring(vim.version()) },
    editorPluginInfo = { name = "copilot-language-server", version = "*" },
  },
  settings = {
    telemetry = {
      telemetryLevel = "all",
    },
  },
  on_attach = function(client, bufnr)
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      if ds.cmp.inline.available() then ds.cmp.inline.enable(true) end
    end

    vim.api.nvim_buf_create_user_command(
      bufnr,
      "LspCopilotSignIn",
      function() sign_in(bufnr, client) end,
      { desc = "copilot: sign in with GitHub account" }
    )
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "LspCopilotSignOut",
      function() sign_out(bufnr, client) end,
      { desc = "copilot: sign out with GitHub account" }
    )
  end,
}

return function() return M end
