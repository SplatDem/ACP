mem dup 72  store8 ;; H
1 + dup 101 store8 ;; e
1 + dup 105 store8 ;; i
1 + dup 108 store8 ;; l
1 + dup 32  store8 ;; SPACE
1 + dup 80  store8 ;; P
1 + dup 101 store8 ;; e
1 + dup 111 store8 ;; o
1 + dup 112 store8 ;; p
1 + dup 108 store8 ;; l
1 + dup 101 store8 ;; e
1 + dup 10  store8 ;; \n
1 +
mem - mem 1 1 r= r= r= r= syscall

