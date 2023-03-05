;; inherits: yaml

; (block_mapping_pair key: (_) @function)

(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @field))
  value: (flow_node (plain_scalar (string_scalar) @text.title))
  (#eq? @field "title")
)
