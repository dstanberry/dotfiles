; inherits: yaml

; (block_mapping_pair key: (_) @function)

(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @variable.member))
  value: (flow_node (plain_scalar (string_scalar) @markup.heading))
  (#eq? @variable.member "title")
)

(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @variable.member))
  value: (flow_node (plain_scalar (string_scalar) @annotation))
  (#eq? @variable.member "date")
)

(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @variable.member))
  value: (flow_node (flow_sequence (flow_node (plain_scalar (string_scalar) @annotation))))
  (#eq? @variable.member "tags")
)
