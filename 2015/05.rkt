#lang racket

(define raw-input (sequence->list (in-lines)))
(define list-input (map string->list raw-input))


(define (test x)
  (or (and x 1) 0))

(define (three-vowels? lst)
    (> (length 
         (indexes-where lst (lambda (char) (string-contains? "aeiou" (~a char)))))
       2))

(define (2-letters-in-a-row? lst)
    (for/or ([first-char (drop-right lst 1)]
             [second-char (drop lst 1)])
            (char=? first-char second-char)))

(define (no-ab-cd-pq-xy? lst)
    (not (for/or ([first-char (drop-right lst 1)]
                  [second-char (drop lst 1)])
                 (string-contains? "ab cd pq xy" (string first-char second-char)))))

(define (two-pairs? lst)
    (for*/or ([i (- (length lst) 2)]
                [j (in-range (+ i 2) (length lst))])
               (> (length (take-common-prefix (drop lst i) (drop lst j))) 1)))

(define (x_x? lst)
    (for/or ([first-char lst]
             [third-char (drop lst 2)])
            (char=? first-char third-char)))

(define part-1 
  (apply + (map (lambda (lst) 
                  (test (and (three-vowels? lst) 
                             (2-letters-in-a-row? lst) 
                             (no-ab-cd-pq-xy? lst))))
                list-input)))

(define part-2 
  (apply + (map (lambda (lst) 
                  (test (and (two-pairs? lst) 
                             (x_x? lst)))) 
                list-input)))

(printf "Part 1: ~a\nPart 2: ~a\n" part-1 part-2)
