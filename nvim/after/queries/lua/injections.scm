; (
; 	(function_call
; 		(field_expression) @_vimcmd_identifier
; 		(arguments
; 			(string) @vim)
;   )
;
; 	(#any-of? @_vimcmd_identifier "vim.cmd" "vim.api.nvim_command" "vim.api.nvim_exec")
; 	(#match? @vim "^[\"']")
; 	(#offset! @vim 0 1 0 -1)
; )
;
; (
; 	(function_call
; 		(field_expression) @_vimcmd_identifier
; 		(arguments
; 			(string) @vim)
; 	)
;
; 	(#any-of? @_vimcmd_identifier "vim.cmd" "vim.api.nvim_command" "vim.api.nvim_exec")
; 	; (#match? @vim "^\\[\\[")
; 	(#offset! @vim 0 2 0 -2)
; )
