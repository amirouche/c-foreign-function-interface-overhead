(import (chezscheme))


(define (now)
  (define now (current-time 'time-monotonic))
  (fx+ (fx* (time-second now) (expt 10 3))
       (fx/ (time-nanosecond now) (expt 10 6))))


(define libfrob (load-shared-object "./libfrob.so"))

(define frob (foreign-procedure "frob" (int) int))

(define i (string->number (cadr (command-line))))

(define start (now))

(define x (let loop ((i i)
                     (x 0))
            (if (fxzero? i)
                x
                (loop (fx- i 1) (frob x)))))

(display "out: Chez C FFI wall-clock time: ")
(display (- (now) start))
(newline)
(format #t "out: ~a\n" x)
