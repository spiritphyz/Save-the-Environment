; Make Tree-sitter provide syntax highlighting inside Vue template strings
; make sure /* html */ is before the string
(pair
  key: (property_identifier) @_name
    (#eq? @_name "template")
    value: (template_string) @html
)
