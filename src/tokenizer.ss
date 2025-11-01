;; ACP Tokenizer (LL)
;; Here will be a description of some helpful
;; functions just for better understanding
;; of how to use scheme

(load "./defines.ss")

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
    ;; (set! tokens (cons (list type value position) tokens))) Maybe just don't return the position
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

  (define (parse-identifire-or-keyword)
    (let ((start-position position))
      (let loop ()
	(when (or (char-alphabetic? (current-char))
		 (char-numeric? (current-char))
		 (char=? (current-char) #\_))
	 (next-char)
	 (loop)))
      (let ((ident (substring src start-position position)))
	(add-token
	 (cond
	   ((member ident '("int" "float" "double" "char" "void" "unsigned" "short" "signed" "long")) 'TYPE)
	   ((member ident '("if" "else" "while" "for" "do" "switch" "case" "default" "break" "continue" "return" "goto" "as" "import" "pub")) 'KEYWORD)
	   ((member ident '("const" "static" "extern" "register" "volatile")) 'STORAGE_CLASS)
	   ((member ident '("struct" "enum" "union" "typedef")) 'STRUCTURE_KEYWORD)
	   ((member ident '("sizeof")) 'OPERATOR)
	   (else 'IDENTIFIER))
	 ident))))

  ;; String literals
  (define (parse-string-literal)
    (let ((start-position position)
	 (delimiter (current-char)))
      (next-char)
      (let loop ()
	(cond
	 ((char=? (current-char) #\nul)
	  (trace-log-error "Unterminated string literal"))
	 ((char=? (current-char) delimiter)
	  (next-char)
	  (let ((str (substring src start-position position)))
	    (add-token 'STRING str)))
	 ((char=? (current-char) #\\)
	  (next-char)
	  (when (not (char=? (current-char) #\nul))
	    (next-char))
	  (loop))
	 (else
	   (next-char)
	   (loop))))))

  ;; Character literals
  (define (parse-char-literal)
    (let ((start-position position)
	 (delimiter (current-char)))
      (next-char) ;; Skip opening quote
      (let loop ()
	(cond
	 ((char=? (current-char) #\nul)
	  (trace-log-error "Unterminated character literal"))
	 ((char=? (current-char) delimiter)
	  (next-char)
	  (let ((char-str (substring src start-position position)))
	    (add-token 'CHARACTER char-str)))
	 ((char=? (current-char) #\\)
	  (next-char)
	  (when (not (char=? (current-char) #\nul))
	    (next-char))
	  (loop))
	 (else
	   (next-char)
	   (loop))))))

  ;; Operators and punctuation
  (define (parse-operator-or-punctuation)
    (let ((ch (current-char)))
      (case ch
	((#\+)
	 (if (char=? (next-char) #\+)
	     (begin (next-char) (add-token 'OPERATOR "++"))
	     (add-token 'OPERATOR "+")))
	((#\-)
	 (if (char=? (current-char) #\-)
	     (begin (next-char) (add-token 'OPERATOR "--"))
	     (add-token 'OPERATOR "-")))
	((#\* ) (next-char) (add-token 'OPERATOR "*"))
	((#\/ ) (next-char) (add-token 'OPERATOR "/"))
	((#\= )
	 (if (char=? (next-char) #\=)
	     (begin (next-char) (add-token 'OPERATOR "=="))
	     (add-token 'OPERATOR "=")))
	((#\! )
	 (if (char=? (next-char) #\=)
	     (begin (next-char) (add-token 'OPERATOR "!="))
	     (add-token 'OPERATOR "!")))
	((#\< )
	 (if (char=? (next-char) #\=)
	     (begin (next-char) (add-token 'OPERATOR "<="))
	     (add-token 'OPERATOR "<")))
	((#\> )
	 (if (char=? (next-char) #\=)
	     (begin (next-char) (add-token 'OPERATOR ">="))
	     (add-token 'OPERATOR ">")))
	((#\& )
	 (if (char=? (next-char) #\&)
	     (begin (next-char) (add-token 'OPERATOR "&&"))
	     (add-token 'OPERATOR "&")))
	((#\| )
	 (if (char=? (next-char) #\|)
	     (begin (next-char) (add-token 'OPERATOR "||"))
	     (add-token 'OPERATOR "|")))
	((#\~ ) (next-char) (add-token 'OPERATOR "~"))
	((#\^ ) (next-char) (add-token 'OPERATOR "^"))
	((#\% ) (next-char) (add-token 'OPERATOR "%"))
	((#\? ) (next-char) (add-token 'OPERATOR "?"))
	((#\: ) (next-char) (add-token 'OPERATOR ":"))
	((#\; ) (next-char) (add-token 'PUNCTUATION ";"))
	((#\, ) (next-char) (add-token 'PUNCTUATION ","))
	((#\. ) (next-char) (add-token 'OPERATOR "."))
	((#\( ) (next-char) (add-token 'PUNCTUATION "("))
	((#\) ) (next-char) (add-token 'PUNCTUATION ")"))
	((#\[ ) (next-char) (add-token 'PUNCTUATION "["))
	((#\] ) (next-char) (add-token 'PUNCTUATION "]"))
	((#\{ ) (next-char) (add-token 'PUNCTUATION "{"))
	((#\} ) (next-char) (add-token 'PUNCTUATION "}"))
	(else (next-char) (add-token 'UNKNOWN (string ch))))))

  ;; Skip comments
  (define (skip-comment)
    (let ((ch (current-char))
	  (next-ch (if (< (+ position 1) src-len)
		       (string-ref src (+ position 1))
		       #\nul)))
      (cond
       ;; Single line comment
       ((and (char=? ch #\/) (char=? next-ch #\/))
	(next-char) (next-char)
	(let loop ()
	  (when (and (not (char=? (current-char) #\nul))
		     (not (char=? (current-char) #\newline)))
	    (next-char)
	    (loop))))
       ;; Multi-line comment  
       ((and (char=? ch #\/) (char=? next-ch #\*))
	(next-char) (next-char)
	(let loop ()
	  (cond
	   ((char=? (current-char) #\nul)
	    (trace-log-error "Unterminated comment"))
	   ((and (char=? (current-char) #\*) 
		 (char=? (if (< (+ position 1) src-len)
			     (string-ref src (+ position 1))
			     #\nul) #\/))
	    (next-char) (next-char))
	   (else
	    (next-char)
	    (loop)))))
       (else #f))))

  (define (main-loop)
   (skip-whitespace)
   (cond
     ((>= position src-len) 'done)
     
     ((char-numeric? (current-char))
      (parse-number))
     
     ((or (char-alphabetic? (current-char))
          (char=? (current-char) #\_))
      (parse-identifire-or-keyword))
     
     ;; String literal
     ((char=? (current-char) #\")
      (parse-string-literal))

     ;; Character literal
     ((char=? (current-char) #\')
      (parse-char-literal))

     ;; FIX
     ;; Check how to write '\n' in scheme
     ;; ((char=? (current-char) #\\n)
     ;;  (set! line (+ line 1)))

     ;; Comments
     ((and (char=? (current-char) #\/)
	   (< (+ position 1) src-len)
	   (or (char=? (string-ref src (+ position 1)) #\/)
	       (char=? (string-ref src (+ position 1)) #\*)))
      (skip-comment)
      (main-loop))
     
     ;; Operators and punctuation
     ((member (current-char) '(#\+ #\- #\* #\/ #\= #\! #\< #\> #\& #\| #\~ #\^ #\% #\? #\: #\; #\, #\. #\( #\) #\[ #\] #\{ #\}))
      (parse-operator-or-punctuation))
     
     (else
      (next-char)
      (add-token 'UNKNOWN (string (current-char)))))
   
   (when (< position src-len)
     (main-loop)))
  
  (main-loop)

  ;; Return tokens
  (reverse tokens)))
