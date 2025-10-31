#!/usr/bin/chezscheme --script

;; Compiler written in Chez scheme

(import (chezscheme))
(import (rnrs))

(load "./defines.ss")
(load "./tokenizer.ss")

(define args (command-line))

(display args)
(newline)

(define (print-usage-and-exit) (trace-log-error (string-append "Usage: " (car args) " <input.acp>" " <output> " "<target>\n")) (exit EXIT_FAILURE))

(if (< (length args) 3)
  (print-usage-and-exit))

(if (null? (cdr args))
  (print-usage-and-exit)
  (trace-log-info "Args... Ok\n"))

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

(trace-log-info (string-append "Compiling ACP code to " (list-ref args 3)))
(newline)

(trace-log-debug "Running tests...\n")
(define (do-tests)
  (define (tokenizer-test)
    (trace-log-debug "Testing tokenizer with numbers:\n")
    (trace-log-debug "TYPE | VALUE | SIZE\n")
    (trace-log-debug "INEGER TEST:\n")
    (display (tokenize "1488"))
    (newline)
    (trace-log-debug "FLOAT TEST:\n")
    (display (tokenize "14.88"))
    (newline)
    (trace-log-debug "BOTH INT AND FLOAT TEST:\n")
    (display (tokenize "1488 14.88"))
    (newline)
    (trace-log-debug "FROM ARGC 1 TEST:\n")
    (display (tokenize (list-ref args 1)))
    (newline))
  
  (tokenizer-test))

(do-tests)
