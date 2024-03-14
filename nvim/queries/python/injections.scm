; extends

(assignment
  left: (identifier) @_id (#contains? @_id "query")
  right: (string (string_content) @injection.content
	(#set! injection.language "sql")
	(#set! injection.include-children)
	(#set! injection.combined)
))

(assignment
  left: (identifier) @_id (#contains? @_id "sql")
  right: (string (string_content) @injection.content
	(#set! injection.language "sql")
	(#set! injection.include-children)
	(#set! injection.combined)
))
