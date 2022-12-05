#lang racket

(require threading)

(define (rotate lst-of-lst)
  (apply map list lst-of-lst))

(define raw-input (sequence->list (in-lines)))
(define-values (crate-lines move-lines) (splitf-at raw-input non-empty-string?))

(define crates (for/list ([i (in-naturals)]
                          [crate (~>> crate-lines
                                      (map string->list)
                                      rotate
                                      (map reverse))]
                          #:when (= (modulo i 4) 1))
                         (takef crate char-graphic?)))

(define moves (for/list ([line move-lines]
                         #:when (non-empty-string? line))
                        (~>> line
                             (regexp-match* #rx"[0-9]+")
                             (map string->number))))

(define (draw-crates crates)
  (for ([col crates]) (printf "~a\n" col))
  (newline))

(define (solve crates moves op)
  (if (empty? moves) 
    crates
    (match-let 
      ([(list n from to) (first moves)])
      (solve (for/list ([col crates])
                       (match (- (char->integer (first col)) 48)
                              [(== from) (drop-right col n)]
                              [(== to) (append col (op (take-right (list-ref crates (- from 1)) n)))]
                              [_ col]))
             (rest moves)
             op))))

(printf "Part 1: ~a\nPart 2: ~a\n"
        (list->string (map last (solve crates moves reverse)))
        (list->string (map last (solve crates moves identity))))

