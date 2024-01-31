; extends

(class_definition
  superclasses: (argument_list
                  (identifier) @type))

((identifier) @constant
 (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))
