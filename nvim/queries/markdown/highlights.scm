; extends

(atx_h1_marker) @markup.heading
((atx_h1_marker) heading_content: (_) @text.title)
(atx_h2_marker) @markup.heading
((atx_h2_marker) heading_content: (_) @markup.heading)

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

(pipe_table_header
  "|" @punctuation.special (#set! conceal "│"))

(pipe_table_delimiter_row
  "|" @punctuation.special (#set! conceal "├")
  (pipe_table_delimiter_cell))

(pipe_table_delimiter_row
  (pipe_table_delimiter_cell)
  "|" @punctuation.special (#set! conceal "┤"))

(pipe_table_delimiter_row
  (pipe_table_delimiter_cell)
  "|" @punctuation.special (#set! conceal "┼")
  (pipe_table_delimiter_cell))

(pipe_table_delimiter_cell
  "-" @punctuation.special (#set! conceal "─"))

(pipe_table_row
  "|" @punctuation.special (#set! conceal "│"))

((pipe_table_align_left) @punctuation.special (#set! conceal "─"))

((pipe_table_align_right) @punctuation.special (#set! conceal "─"))
