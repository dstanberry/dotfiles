---@class remote.lsp.config
local M = {}

M.config = {
  cmd = { "pylance", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  single_file_support = true,
  settings = {
    python = {
      analysis = {
        addImport = { exactMatchOnly = true },
        autoSearchPaths = true,
        autoFormatStrings = true,
        autoImportCompletions = true,
        autoImportUserSymbols = true,
        completeFunctionParens = true,
        diagnosticMode = "workspace", ---@type "workspace"|"openFilesOnly"
        enablePytestExtra = false,
        enablePytestSupport = true,
        importFormat = "absolute", ---@type "absolute"|"relative"
        indexing = true,
        inlayHints = {
          callArgumentNames = "partial", ---@type "off"|"partial"|"all"
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
        logLevel = "Warning", ---@type "Trace"|"Information"|"Warning"|"Error"
        stubPath = "typings",
        typeCheckingMode = "basic", ---@type "off"|"basic"|"standard"|"strict"
        useLibraryCodeForTypes = true,
      },
      telemetry = {
        telemetryLevel = "off",
      },
    },
  },
  on_attach = function(client, bufnr)
    local handlers = require "remote.lsp.handlers"

    local _method = function()
      local _, range = ds.buffer.get_visual_selection()
      local params = ds.buffer.make_lsp_range_params(range)
      handlers.execute_command {
        command = "pylance.extractMethod",
        arguments = { vim.uri_from_bufnr(bufnr):gsub("file://", ""), params.range },
      }
    end

    local _variable = function()
      local _, range = ds.buffer.get_visual_selection()
      local params = ds.buffer.make_lsp_range_params(range)
      handlers.execute_command {
        command = "pylance.extractVariable",
        arguments = { vim.uri_from_bufnr(bufnr):gsub("file://", ""), params.range },
      }
    end

    vim.lsp.handlers["workspace/executeCommand"] = function(_, result)
      if result and result.label == "Extract Method" then
        local old_value = result.data.newSymbolName
        local file = vim.tbl_keys(result.edits.changes)[1]
        local range = result.edits.changes[file][1].range.start
        local params = { textDocument = { uri = file }, position = range }
        local prompt_opts = {
          prompt = "New Method Name: ",
          default = old_value,
        }
        if not old_value:find "new_var" then range.character = range.character + 5 end
        vim.ui.input(prompt_opts, function(input)
          if not input or #input == 0 then return end
          params.newName = input
          local handler = client.handlers["textDocument/rename"] or vim.lsp.handlers["textDocument/rename"]
          client:request("textDocument/rename", params, handler, bufnr)
        end)
      end
    end

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (python)" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", _method, { buffer = bufnr, desc = "python: extract method" })
    vim.keymap.set({ "n", "v" }, "<leader>lv", _variable, { buffer = bufnr, desc = "python: extract variable" })
  end,
}

return M
