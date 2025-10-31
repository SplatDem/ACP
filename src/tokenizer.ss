;; ACP Tokenizer (LL)
;; Here will be a description of some helpful
;; functions just for better understanding
;; of how to use scheme

(define (tokenize src)
  (let ((tokens '())
	(position 0)
	(src-len (string-length src)))

  ;; Get current char 
  ;; if the position is < than src length
  (define (current-char) 
    (if (< position src-len)
      (string-ref src position)
      #\nul))

  ;; Get next char
  ;; Redefine position by adding 1
  (define (next-char) 
    (set! position (+ position 1))
    (current-char))

  ;; Skip whitespaces
  ;; It's more like imperative style btw :)
  (define (skip-whitespace)
    (let loop ()
      (when (and (< position src-len)
		(char-whitespace? (current-char)))
	(next-char)
	(loop))))

  ;; Add token to a token list
  ;; By creating a pair betweem
  ;; token type and token value,
  ;; pushing her to the token 
  ;; list and returning new list
  (define (add-token type value)
    (set! tokens (cons (list type value position) tokens)))

  ;; Here is a couple of functions to define a token type

  ;; Number (TODO)
  ;; Reading a number while
  ;; current char is 0..9
  ;; and setting has-dot to 
  ;; true if current char is a dot.
  ;; Then returning number with type
  (define (parse-number) 
    (let ((start-position position)
	   (has-dot #f))
	 (let loop () ;; Weird shit
	   (cond 
	     ((char-numeric? (current-char))
	      (next-char)
	      (loop))
	     ((and (char=? (current-char) #\.) (not has-dot))
		   (set! has-dot #t)
		   (next-char)
		   (loop))
	      (else
		(let ((num-str (substring src start-position position)))
		  (add-token (if has-dot 'FLOAT 'INTEGER) num-str)))))))

  (define (main-loop)
    (skip-whitespace)
    (when (char-numeric? (current-char))
      (parse-number)
      (main-loop)))

  (main-loop)
  
  ;; Return tokens
  (reverse tokens)))
