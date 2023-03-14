;; extends

(atx_h1_marker) @text.title
((atx_h1_marker) heading_content: (_) @text.title)
(atx_h2_marker) @text.heading
((atx_h2_marker) heading_content: (_) @text.heading)

[
  (atx_h3_marker)
  (atx_h4_marker)
  (atx_h5_marker)
  (atx_h6_marker)
] @variable.builtin
((atx_h3_marker) heading_content: (_) @variable.builtin)
((atx_h4_marker) heading_content: (_) @variable.builtin)
((atx_h5_marker) heading_content: (_) @variable.builtin)
((atx_h6_marker) heading_content: (_) @variable.builtin)


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

; ((list_marker_star) @punctuation.special (#set! conceal "✸ ") (#eq? @punctuation.special "* "))
; ((list_marker_plus) @punctuation.special (#set! conceal "✿ ") (#eq? @punctuation.special "+ "))
; ((list_marker_minus) @punctuation.special (#set! conceal "• ") (#eq? @punctuation.special "- "))
; ((list_marker_dot) @conceal (#set! conceal "• ") (#eq? @punctuation.special ". "))
; ((task_list_marker_checked) @punctuation.special (#set! conceal ""))
; ((task_list_marker_unchecked) @punctuation.special (#set! conceal ""))
