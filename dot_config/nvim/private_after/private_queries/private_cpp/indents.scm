;; extends

(namespace_definition
	body: (_) @indent.begin)

((assignment_expression) @indent.begin
 (#set! indent.start_at_same_line 1)
 (#set! indent.immediate 1))

[
 (template_argument_list)
 (template_parameter_list)
 ] @indent.begin
