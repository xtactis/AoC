#lang racket

(require threading)

(define (addf x) (list x #f))

(define input (for/list ([lst (in-lines)])
                        (~>> lst
                             string->list
                             (map char->integer)
                             (map (curry + -48))
                             (map addf))))

(define (find_visible_trees line height)
  (if (empty? line)
    '()
    (append (list (list (caar line) (or (cadar line) (> (caar line) height))))
            (find_visible_trees (rest line) (max (caar line) height)))))

(define (transpose mat)
  (apply map list mat))

(define (rotate mat) 
  (reverse (transpose mat)))

(define (find_all_visible_trees mat)
  (for/list ([line mat])
            (find_visible_trees line -1)))

(count identity (flatten (~>> input
                              find_all_visible_trees
                              rotate
                              find_all_visible_trees
                              rotate
                              find_all_visible_trees
                              rotate
                              find_all_visible_trees
                              (map (curry map cdr)))))

(define (count_visible_trees line height)
  (define taketh (takef line (lambda (p) (< (car p) height))))
  (min (length line) (+ 1 (length taketh))))

(define inputT (transpose input))
(for*/fold ([part-2 0])
           ([i (in-range (length input))]
            [j (in-range (length (first input)))])
           (define row (list-ref input i))
           (define col (list-ref inputT j))
           (define cur (car (list-ref row j)))
           (max part-2 (* (count_visible_trees (reverse (take row j)) cur)
                          (count_visible_trees (rest (drop row j)) cur)
                          (count_visible_trees (reverse (take col i)) cur)
                          (count_visible_trees (rest (drop col i)) cur))))

