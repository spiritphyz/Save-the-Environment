;extends

; JavaScript in script tags
((script_element
  (raw_text) @injection.content)
  (#set! injection.language "javascript"))

; CSS in style tags
((style_element
 (raw_text) @injection.content)
 (#set! injection.language "css"))
