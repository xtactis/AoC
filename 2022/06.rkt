#lang racket

(require threading)

(define input (~>> (in-lines)
                   sequence->list
                   first
                   string->list))

(define (solve lst i n)
  (if (check-duplicates (take lst n)) 
    (solve (rest lst) (+ i 1) n)
    (+ i n)))

(map (curry solve input 0) '(4 14))

