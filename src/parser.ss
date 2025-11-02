;; ACP ast - see structure
;; in the ../struct.ast

(load "./ast-def.ss")

(define (parse-and-generate-ast tokens) 
  (let ((position 0))
    
    ;; Find current token
    ;; every token has own position
    ;; in the token list, so we can
    ;; just ref to this position
    (define (current-token) 
      (if (< current-position (length tokens))
        (list-ref tokens current-position)
        '(EOF "" -1)))

    ;; Just inc the position
    (define (next-token)
      (set! current-position (+ current-position 1))
      
    (define (peek-token)
      (if (< (+ current-position 1) (length tokens))
        (list-ref tokens (+ current-position 1))
        '(EOF "" -1)))

      ;; Token list element structure:
      ;; (type value position)

      (define (token-type token)
        (car token))

      (define (token-value token)
        (cadr token))
      
      (define (token-posistion token)
        (caddr token))

      (define (expect type . expected-values)
        (let ((token (current-token)))
          (if (and (eq? (token-type token) type)
            (or (null? expected-values)
                (member (token-value token) expected-values)))))))))
