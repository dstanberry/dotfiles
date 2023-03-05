;; extends

(atx_h1_marker) @attribute
((atx_h1_marker) heading_content: (_) @attribute)
(atx_h2_marker) @label
((atx_h2_marker) heading_content: (_) @label)
(atx_h3_marker) @constant.builtin
((atx_h3_marker) heading_content: (_) @constant.builtin)
(atx_h4_marker) @constant.macro
((atx_h4_marker) heading_content: (_) @constant.macro)
(atx_h5_marker) @constructor
((atx_h5_marker) heading_content: (_) @constructor)
(atx_h6_marker) @punctuation.special
((atx_h6_marker) heading_content: (_) @punctuation.special)

(list_item [
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @conceal [
    (task_list_marker_checked)
    (task_list_marker_unchecked)
](#set! conceal ""))

((list_marker_star) @punctuation.special (#set! conceal "✸ ") (#eq? @punctuation.special "* "))
((list_marker_plus) @punctuation.special (#set! conceal "✿ ") (#eq? @punctuation.special "+ "))
((list_marker_minus) @punctuation.special (#set! conceal "• ") (#eq? @punctuation.special "- "))
; ((list_marker_dot) @conceal (#set! conceal "• ") (#eq? @punctuation.special ". "))
((task_list_marker_checked) @punctuation.special (#set! conceal ""))
((task_list_marker_unchecked) @punctuation.special (#set! conceal ""))
