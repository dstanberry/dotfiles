local handlers = require "remote.lsp.handlers"

local M = {}

local cmd = { "vtsls", "--stdio" }

local function get_cmd()
  if ds.has "win32" then cmd[1] = vim.fn.exepath(cmd[1]) end
  return cmd
end

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
  cmd = cmd,
  on_new_config = function(new_config, _) new_config.cmd = get_cmd() end,
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
    },
    tsserver = {
      globalPlugins = {
        {
          name = "@angular/language-server",
          location = ds.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
          enableForWorkspaceTypeScriptVersions = true,
        },
      },
    },
    typescript = ts_settings,
    javascript = ts_settings,
  },
  on_attach = function(client, bufnr)
    handlers.on_attach(client, bufnr)
    client.commands["_typescript.movetofilerefactoring"] = function(command, _)
      local action, uri, range = unpack(command.arguments)

      local function move(new_fname)
        client.request("workspace/executecommand", {
          command = command.command,
          arguments = { action, uri, range, new_fname },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client.request("workspace/executecommand", {
        command = "typescript.tsserverrequest",
        arguments = {
          "getmovetorefactoringfilesuggestions",
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
        table.insert(files, 1, "enter new path...")
        vim.ui.select(files, {
          prompt = "select move destination:",
          format_item = function(f) return vim.fn.fnamemodify(f, ":~:.") end,
        }, function(f)
          if f and f:find "^enter new path" then
            vim.ui.input({
              prompt = "enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file",
            }, function(new_fname) return new_fname and move(new_fname) end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end,
}

return M
