(load "./defines.ss")

;; AST node
(define-record-type <ast-node>
  (make-ast-node type position)
  ast-node?
  (type ast-node-type)
  (position ast-node-position))

;; Program
(define-record-type <program>
  (make-program declaration)
  program?
  (declaration program-declaration))

;; Import declaration
(define-record-type <import-declaration>
  (make-import-declaration module-name alias position)
  import-declaration?
  (module-name import-declaration-nodule-name)
  (alias import-declaration-alias-name)
  (position import-declaration-position))

;; Function-declaration
(define-record-type <function-declaration>
  (make-function-declaration pub? return-type name args body position)
  function-declaration?
  (pub? function-declaration-pub)
  (return-type function-declaration-return-type)
  (name function-declaration-name)
  (args function-declaration-args)
  (body function-declaration-body)
  (position function-declaration-position))

;; Function arguments
(define-record-type <arg>
  (make-arg type name position)
  arg?
  (type arg-type)
  (name arg-name)
  (position arg-position))

;; Code block
(define-record-type <block>
  (make-block statements position)
  block?
  (statements block-statements)
  (position block-position))

;; Function call
(define-record-type <call-exrp>
  (make-call-expr callee ags position)
  call-expr?
  (callee call-expr-callee)
  (args call-expr-args)
  (position call-expr-position))

(define-record-type <member-expr>
  (make-member-expr object member position)
  make-expr?
  (object member-expr-object)
  (member member-expr-member)
  (position member-expr-position))

;; Identifier
(define-record-type <identifier>
  (make-identifier name position)
  identifier?
  (name identifier-name)
  (position identifier-position))

;; String literal
(define-record-type <string-lit>
  (make-string-lit value position)
  string-lit?
  (value string-lit-value)
  (position string-lit-position))

;; Integer literal
(define-record-type <int-lit>
  (make-int-lit value position)
  int-lit?
  (value int-lit-value)
  (position int-lit-position))

;; Return statement
(define-record-type <return-stmt>
  (make-return-stmt value position)
  return-stmt?
  (value return-stmt-value)
  (position return-stmt-position))
