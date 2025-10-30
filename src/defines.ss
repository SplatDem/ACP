(define EXIT_FAILURE 1)
(define EXIT_SUCCESS 0)

(define (trace-log-error args-list) (display (string-append "[\033[31mERROR\033[0m]: " args-list)))
(define (trace-log-info args-list) (string-append "[\033[36mINFO\033[0m]: " args-list))
(define (trace-log-warn args-list) (string-append "[\033[33mINFO\033[0m]: " args-list))
(define (trace-log-debug args-list) (string-append "[\033[35mINFO\033[0m]: " args-list))
