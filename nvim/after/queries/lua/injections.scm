(
	(function_call
		(field_expression
			(identifier) @_vimscript_identifier_1
			(property_identifier) @_vimscript_identifier_2)
		(arguments
			(string) @vim)
	)

	(#eq? @_vimscript_identifier_1 "vim")
	(#eq? @_vimscript_identifier_2 "cmd")
	(#match? @vim "^\\[\\[")

)
