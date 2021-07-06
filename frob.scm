(import (chezscheme))


(define (now)
  (define now (current-time 'time-monotonic))
  (+ (fx* (time-second now) 1000)
     (fx/ (time-nanosecond now) 1000000)))


(define libfrob (load-shared-object "./libfrob.so"))

(define frob (foreign-procedure __collect_safe "frob" (int) int))


(define start (now))

(let loop ((i (string->number (cadr (command-line))))
           (x 0))
  (unless (fxzero? i)
    (loop (fx- i 1) (frob x))))

(display (fx- (now) start)) (newline)
