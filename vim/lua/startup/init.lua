---------------------------------------------------------------
-- => Enable Language Server Protocol support
---------------------------------------------------------------
function startLSP()
	local on_attach_vim = function(_,bufnr)
		require('completion').on_attach()
	end
	local servers = {'bashls', 'jsonls', 'vimls'}
	for _, server in ipairs(servers) do
		require'lspconfig'[server].setup {
			on_attach=on_attach_vim
		}
	end
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			signs = true,
			update_in_insert = false,
			virtual_text = {
				prefix = '▪',
				spacing = 4
			}
		}
	)
end

---------------------------------------------------------------
-- => Helper Functions
---------------------------------------------------------------
-- print inspection of variable
P = function(v)
	print(vim.inspect(v))
	return v
end

-- enable live-reloading of lua functions
if pcall(require, 'plenary') then
	RELOAD = require('plenary.reload').reload_module

R = function(name)
		RELOAD(name)
		return require(name)
	end
end
