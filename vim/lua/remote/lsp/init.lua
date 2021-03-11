---------------------------------------------------------------
-- => Language Server Protocol Configuration
---------------------------------------------------------------
-- verify lspconfig is available
local has_lsp, lspconfig = pcall(require, 'lspconfig')
local lspconfig_util = pcall(require, 'lspconfig.util')
if not has_lsp then
	return
end

-- add language servers
local on_attach_vim = function(_,bufnr)
	require('completion').on_attach()
end
local servers = {'bashls', 'jsonls', 'pyright', 'vimls'}
for _, server in ipairs(servers) do
	require'lspconfig'[server].setup {
		on_attach=on_attach_vim
	}
end

-- add lua language server
require('nlua.lsp.nvim').setup(lspconfig, {
	on_attach = on_attach_vim,
	root_dir = function(fname)
		if string.find(vim.fn.fnamemodify(fname, ":p"), ".config") then
			return vim.fn.expand("~/.config")
		end
		return lspconfig_util.find_git_ancestor(fname)
			or lspconfig_util.path.dirname(fname)
	end,
	globals = {
	"Color", "c", "Group", "g", "s",
	"RELOAD",
	}
})

-- set diagnostics options
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

-- load lsp completion settings
require('remote.completion')
