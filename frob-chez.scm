(import (chezscheme))


(define (now)
  (define now (current-time 'time-monotonic))
  (+ (fx* (time-second now) 1000)
     (fx/ (time-nanosecond now) 1000000)))

(define (frob int)
  (fxmodulo (fx+ int 1) 1000000))

(define count (string->number (cadr (command-line))))

(define start (now))

(define x (let loop ((i count)
                     (x 0))
            (if (fxzero? i)
                x
                (loop (fx- i 1) (frob x)))))
  
(display "out: Only Chez wall-clock time: ")
(display (fx- (now) start))
(newline)
(format #t "out: ~a\n" x)
