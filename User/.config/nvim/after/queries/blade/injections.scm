; Inject PHP syntax into blade parameters
((parameter) @injection.content
  (#set! injection.language "php_only")
  (#set! injection.include-children))

; Inject PHP into php_statement blocks
((php_statement) @injection.content
  (#set! injection.language "php"))

; Inject PHP into php_only blocks
((php_only) @injection.content
  (#set! injection.language "php"))

; Inject HTML into the document
((text) @injection.content
  (#set! injection.language "html"))
