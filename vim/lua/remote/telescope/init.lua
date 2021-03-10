---------------------------------------------------------------
-- => Telescope Configuration
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, 'telescope') then
	return
end

-- reload telescope and it's dependencies
local should_reload = true
local reloader = function()
	if should_reload then
		RELOAD('plenary')
		RELOAD('popup')
		RELOAD('telescope')
	end
end
reloader()

-- bring telescope functions into local scope
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')

-- set default options
require('telescope').setup {
	defaults = {
		prompt_prefix = '❯ ',
		selection_caret = '❯ ',
		winblend = 0,
		preview_cutoff = 120,
		layout_strategy = 'horizontal',
		layout_defaults = {
			horizontal = {
				width_padding = 0.1,
				height_padding = 0.1,
				preview_width = 0.6,
			},
			vertical = {
				width_padding = 0.05,
				height_padding = 1,
				preview_height = 0.5,
			}
		},
		selection_strategy = "reset",
		sorting_strategy = "descending",
		scroll_strategy = "cycle",
		prompt_position = "bottom",
		color_devicons = false,
		mappings= {
			i = {
				["<C-x>"] = false,
				["ZZ"] = actions.close,
				["jk"] = actions.close,
				["<esc>"] = actions.close,
				["<C-s>"] = actions.select_horizontal,
				["<C-q>"] = actions.send_to_qflist,
			},
		},
		borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
		file_sorter = sorters.get_fzy_sorter,
		file_previewer = require('telescope.previewers').vim_buffer_cat.new,
		grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
		qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
	},
	extensions= {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
}

-- load additional extensions
require('telescope').load_extension('fzy_native')

-- initialize modules table
local M = {}

-- fuzzy search dotfiles from anywhere
function M.search_dotfiles()
	require("telescope.builtin").find_files({
		cwd = "~/.config",
		hidden = true,
		shorten_path = false,
		layout_strategy = 'horizontal',
		prompt_title = "~ dotfiles ~",
		preview_title = false,
		results_title = false,
	})
end

-- customize generic fuzzy finder
function M.search_cwd()
	require("telescope.builtin").find_files({
		hidden = true,
		shorten_path = true,
		layout_strategy = 'horizontal',
		preview_title = false,
		results_title = false,
	})
end

-- fuzzy search installed vim plugins
function M.installed_plugins()
	require("telescope.builtin").find_files({
		cwd = "~/.config/vim/remote",
		previewer = false,
		layout_strategy = 'vertical',
		results_title = false,
	})
end

-- grep files in cwd
function M.grep_files()
	require("telescope.builtin").grep_string({
		shorten_path = true,
		search = vim.fn.input("Grep ❯ "),
		preview_title = false,
		results_title = false,
	})
end

-- grep all files in cwd
function M.grep_all_files()
	require("telescope.builtin").find_files({
		find_command = { 'rg', '--no-ignore', '--files', },
		preview_title = false,
		results_title = false,
	})
end

-- fuzzy search tracked files in git repository
function M.git_files()
	require("telescope.builtin").find_files(themes.get_dropdown {
		cwd = vim.fn.expand("%:p:h"),
		winblend = 10,
		border = true,
		previewer = false,
		results_title = false,
	})
end

-- call setmetatable whenever any of the custom modules are called
return setmetatable({}, {
	__index = function(_, k)
		reloader()
		if M[k] then
			return M[k]
		else
			return require('telescope.builtin')[k]
		end
	end
})
