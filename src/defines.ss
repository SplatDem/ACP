(define EXIT_FAILURE 1)
(define EXIT_SUCCESS 0)

(define (trace-log-error args-list) (display (format "[\033[31mERROR\033[0m]: ~a\n" args-list)))
(define (trace-log-info args-list) (display (format "[\033[36mINFO\033[0m]: ~a\n" args-list)))
(define (trace-log-warn args-list) (display (format "[\033[33mWARN\033[0m]: ~a\n" args-list)))
(define (trace-log-debug args-list) (display (format "[\033[35mDEBUG\033[0m]: ~a\n" args-list)))
