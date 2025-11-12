;; Logic operation ( a b -- flag )
14 88 != if
	1488 .
else
	420 .
}

;; You also can use some "syntax sugar"

14 88 = if {
	1488 .
else {
	420 .
}

;; Dump operation puts 1 on the top of the stack if it's empty, so you can do that

. if { ;; But this will print 1
	0xe 0x58 + .
else { 420 . }

;; Let's do some stack magic

14 420 88 swap drop > if { 1488 . else 420 . }

