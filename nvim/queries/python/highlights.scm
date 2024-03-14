; extends

(class_definition
  superclasses: (argument_list
                  (identifier) @type))

((identifier) @constant
 (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

; comment corresponding line in stdpath("data")/lazy/nvim-treesitter/queries/python/highlights.scm
((string) @string (#set! "priority" 95))
