local M = {}

local ts_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = {
    completeFunctionCalls = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
}

M.config = {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          {
            name = "@angular/language-server",
            location = ds.plugin.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    javascript = ts_settings,
    typescript = ts_settings,
  },
  on_attach = function(client, bufnr)
    local handlers = require "remote.lsp.handlers"

    handlers.on_attach(client, bufnr)

    client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
      local action, uri, range = unpack(command.arguments)

      local function move(new_fname)
        client.request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, new_fname },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client.request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startline = range.start.line + 1,
            startoffset = range.start.character + 1,
            endline = range["end"].line + 1,
            endoffset = range["end"].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f) vim.fs.dirname(f) end,
        }, function(f)
          if f and f:find "^enter new path" then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fs.joinpath(vim.fs.dirname(fname), ""),
              completion = "file",
            }, function(new_fname) return new_fname and move(new_fname) end)
          elseif f then
            move(f)
          end
        end)
      end)
    end

    local _source = function()
      local params = vim.lsp.util.make_range_params()
      handlers.execute_command {
        command = "typescript.goToSourceDefinition",
        arguments = { params.textDocument.uri, params.position },
        open = true,
      }
    end

    local _refs = function()
      handlers.execute_command {
        command = "typescript.findAllReferences",
        arguments = { vim.uri_from_bufnr(0) },
        open = true,
      }
    end

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (typescript)" })

    vim.keymap.set("n", "<leader>ld", _source, { buffer = bufnr, desc = "typescript: goto source definition" })
    vim.keymap.set("n", "<leader>lr", _refs, { buffer = bufnr, desc = "typescript: show file references" })

    local _organize = handlers.run_code_action["source.organizeImports"]
    local _missing = handlers.run_code_action["source.addMissingImports.ts"]
    local _unused = handlers.run_code_action["source.removeUnused.ts"]
    local _fix = handlers.run_code_action["source.fixAll.ts"]

    vim.keymap.set("n", "<leader>lo", _organize, { buffer = bufnr, desc = "typescript: organize imports" })
    vim.keymap.set("n", "<leader>lm", _missing, { buffer = bufnr, desc = "typescript: add missing imports" })
    vim.keymap.set("n", "<leader>lu", _unused, { buffer = bufnr, desc = "typescript: remove unused imports" })
    vim.keymap.set("n", "<leader>lf", _fix, { buffer = bufnr, desc = "typescript: fix all problems" })
  end,
}

return M
