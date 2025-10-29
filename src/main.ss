;; Compiler written in Chez scheme

(import (chezscheme))
(import (rnrs))

(load "./defines.ss")

(define args (command-line))

(display args)
(newline)

(define usage (string-append "Usage: " (car args) " <input.acp>" " <output> " "<target>\n"))

(if (null? (cdr args))
  (begin
  (display "[ERROR]: Wrong arguments\n")
  (display usage)
  (exit EXIT_FAILURE)
  (newline))
  (display "Args... Ok\n")) ;; TODO: Normal logging

;; 1. Tokenize input source code
;; 2. Put the tokenized result to the ast generator
;; 3. Put ast to the IR (uxntal or C) generator
;; 4. Depend on compilation target, compile the code
(define (compile src target)
  (let* ((tokens (tokenize src)) ;; TODO
         (ast (generate-ast tokens)) ;; TODO
         (ir (generate-ir ast)) ;; TODO
         (output (code-gen ir target))) ;; TODO
  output))

(display (string-append "Compiling ACP code to " (list-ref args 3)))
(newline)
