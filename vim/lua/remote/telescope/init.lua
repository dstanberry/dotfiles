---------------------------------------------------------------
-- => Telescope Configuration
---------------------------------------------------------------
local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')

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
		prompt_position = "top",
		color_devicons = false,
		mappings= {
			i = {
				["<C-x>"] = false,
				["<C-s>"] = actions.select_horizontal,
				["<C-q>"] = actions.send_to_qflist,
			},
		},
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
		file_sorter = sorters.get_fzy_sorter,
		file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
		grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
		qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
	},
	extensions= {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
}
