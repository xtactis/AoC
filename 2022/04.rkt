#lang racket
(require threading)

; actual solution → https://docs.google.com/spreadsheets/d/1x72XcRc8Tm4IYI6woqFD5JL4YF8dPM0SC-9sNgIsub0/edit?usp=sharing

(define input (filter-not (lambda (pairs)
                            (< (second (first pairs)) (first (second pairs))))
                          (for/list ([str (in-lines)]) 
                                    (~>> str
                                    (regexp-match* #rx"[0-9]+")
                                    (map string->number)
                                    ((lambda (x) (call-with-values (lambda () (split-at x 2)) list)))
                                    ; whose fucking idea was it to make some functions return lists of list, 
                                    ; and others return multiple values...
                                    ; also why is there no group-every-k function in the standard library
                                    (sort _ #:key car <)))))

(define overlapped
  (for/list ([pair input])
            (list (min (first (first pair)) (first (second pair)))
                  (max (second (first pair)) (second (second pair))))))

(count member overlapped input)
(count identity overlapped )

