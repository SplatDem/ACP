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
