#lang racket

(require racket/set)

(define (read-input)
  (let ((line (read-line (current-input-port) 'any)))
    (if (eof-object? line)
      '()
      (append (list line) (read-input)))))

(define raw-input (read-input))
(define input-lists (map (lambda (line) (string->list line)) raw-input))

(define split-sets 
    (map (lambda (lst)
         (list (list->set (take lst (/ (length lst) 2)))
               (list->set (drop lst (/ (length lst) 2)))))
         input-lists))

(define (group-by-3 lst)
    (if (= (length lst) 0)
        '()
        (append (list (take lst 3)) (group-by-3 (drop lst 3)))))

(define group-sets (map (lambda (group) (map list->set group)) (group-by-3 input-lists)))

(define (odd-one-out sets)
    (let ([left-set (first sets)] [right-set (second sets)])
        (set-first (set-intersect right-set left-set))))

(define (one-per-group group-of-sets)
    (set-first (set-intersect (first group-of-sets) (second group-of-sets) (third group-of-sets))))

(define (priority-conversion character)
    (if (char-upper-case? character)
        (+ (- (char->integer character) (char->integer #\A)) 27)
        (+ (- (char->integer character) (char->integer #\a)) 1)))

(define part-1 (apply + (map priority-conversion (map odd-one-out split-sets))))
(define part-2 (apply + (map priority-conversion (map one-per-group group-sets))))

(printf "Part 1: ~a\nPart 2: ~a\n" part-1 part-2)
