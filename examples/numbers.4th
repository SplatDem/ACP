;; Example called 'numbers' but it not really about it
;; So here i'll just test the compiler

14 88 + 102 = if 1488 . else 420 endif

14 88 + .

;; While loop
;; Here is a stack
;; ------
;; | 10 | push 10
;; While mark is on a return stack now
;; | 10 | duplite
;; ------
;; Compare stack top and your value 
;; For example 10 > 0
;; ------
;; | 1  |
;; | 10 |
;; ------
;; While stack top is true, do body
 
10 while dup 0 > do
   dup 88 + .
   1 - ;; We have duplicate 10, so it's not dropped
endwhile ;; Jump to the while condition and check if it's true
