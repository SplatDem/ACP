(load "./defines.ss")

;; AST node
(define-record-type ast-node
  (fields type position))

;; Program
(define-record-type <program>
  (fields declaration))

;; Import declaration
(define-record-type <import-declaration>
  (fields module-name alias position))

;; Function-declaration
(define-record-type <function-declaration>
  (fields pub? return-type name args body position))

;; Function arguments
(define-record-type <arg>
  (fields type name position))

;; Code block
(define-record-type <block>
  (fields statements position))

;; Function call
(define-record-type <call-exrp>
  (fields callee ags position))

(define-record-type <member-expr>
  (fields object member position))

;; Identifier
(define-record-type <identifier>
  (fields name position))

;; String literal
(define-record-type <string-lit>
  (fields value position))

;; Integer literal
(define-record-type <int-lit>
  (fields value position))

;; Return statement
(define-record-type <return-stmt>
  (fields value position))
