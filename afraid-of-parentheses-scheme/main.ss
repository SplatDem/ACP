#!/usr/bin/chezscheme --script

;; Compiler written in Chez scheme

(import (chezscheme))
(import (rnrs))

(load "./defines.ss")
(load "./tokenizer.ss")

(load "./parser.ss")

(define args (command-line))

(display args)
(newline)

(define (print-usage-and-exit) (trace-log-error (string-append "Usage: " (car args) " <input.acp>" " <output> " "<target>")) (exit EXIT_FAILURE))

(if (< (length args) 3)
  (print-usage-and-exit))

(if (null? (cdr args))
  (print-usage-and-exit)
  (trace-log-info "Args... Ok"))

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

(trace-log-debug "Running tests...")
(define (do-tests)
  (define (tokenizer-test)
    (trace-log-debug "Testing tokenizer with numbers:")
    ;; (trace-log-debug "TYPE | VALUE | \033[9m\033[2mPOSITION\033[0m")
    (trace-log-debug "TYPE | VALUE | POSITION")
    (trace-log-debug "INEGER TEST:")
    (display (tokenize "1488"))
    (newline)
    (trace-log-debug "FLOAT TEST:")
    (display (tokenize "14.88"))
    (newline)
    (trace-log-debug "BOTH INT AND FLOAT TEST:")
    (display (tokenize "1488 14.88"))
    (newline)
    (trace-log-debug "FROM ARGC 1 TEST:")
    (display (tokenize (list-ref args 1)))
    (newline)
    (trace-log-debug "Testing tokenizer with identifiers and keyword:")
    (display (tokenize "int main return 0;"))
    (newline)
    (trace-log-debug "Real code:")
    (display (tokenize "pub typedef struct A { int a; } A;
		        pub int main() {
		       	  A a = { .a = 0; };
		          return a.a;
		        }"))
    (newline))
  
  (tokenizer-test))

(do-tests)

(parse (tokenize "int main() { return 0; }"))
