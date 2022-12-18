#lang racket

(define (read-next-line-iter file)
        (let ((line (read-line file 'any)))
	     (if (not (eof-object? line))
	         (append (list line) (read-next-line-iter file))
	         '())))

(define (accumulate-calories input)
        (let ([result '(0)] [current-total 0])
             (for ([current-string input])
                  (if (= (string-length current-string) 0)
                      (begin
                        (set! result (append result (list current-total)))
                        (set! current-total 0))
                      (set! current-total (+ current-total (string->number current-string)))))
             (set! result (append result (list current-total)))
             result))

(define input (call-with-input-file "01.in" read-next-line-iter))
(define sorted (sort (accumulate-calories input) >))
(printf "Part 1: ~a\nPart 2: ~a\n" 
	(car sorted)
	(apply + (take sorted 3)))


