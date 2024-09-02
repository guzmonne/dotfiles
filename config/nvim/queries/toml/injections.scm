; extends
(pair
  (bare_key) @_expr
  (#eq? @_expr "template")
  (string) @injection.content
  (#offset! injection.language 1 -11 -1 -3)
  (#set! injection.language "markdown")
)

(pair
  (bare_key) @_expr
  (#eq? @_expr "content")
  (string) @injection.content
  (#offset! injection.language 1 -11 -1 -3)
  (#set! injection.language "markdown")
)

(pair
  (bare_key) @_expr
  (#eq? @_expr "system")
  (string) @injection.content
  (#offset! injection.language 1 -11 -1 -3)
  (#set! injection.language "markdown")
)

