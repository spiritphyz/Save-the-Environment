; Blade-specific highlighting (minimal inheritance of html,php to avoid conflicts)
;extends

; Blade directives
(directive_start) @keyword
(directive_end) @keyword
(directive) @keyword
(conditional_keyword) @keyword

; Parameters
(parameter) @variable

; Comments
(comment) @comment

; PHP
(php_statement) @keyword
(php_only) @keyword

; Constructs
(loop) @repeat
(conditional) @conditional

; HTML tags
; (tag_name) @tag
; (attribute_name) @property
; (attribute_value) @string
; (start_tag) @tag
; (end_tag) @tag

; Content
(text) @none
; (entity) @constant
