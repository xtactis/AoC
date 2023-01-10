#lang racket

(require threading)

(define input (map string->list (sequence->list (in-lines))))

(define start (for/first ([row input]
                          [i (in-naturals)]
                          #:when (member #\S row))
                         (list i (index-of row #\S))))
(define end (for/first ([row input]
                        [i (in-naturals)]
                        #:when (member #\E row))
                       (list i (index-of row #\E))))

(define (el l i j)
  (list-ref (list-ref l i) j))

(define inp (for*/hash ([i (in-range (length input))]
                        [j (in-range (length (first input)))])
                       (values (list i j)
                               (char->integer (match (el input i j)
                                                     [#\S #\a]
                                                     [#\E #\z]
                                                     [_ (el input i j)])))))

(define (check-bounds i j)
  (and (< -1 i (length input)) (< -1 j (length (first input)))))

(define (reachable i j been)
  (for/list ([d '((0 1) (0 -1) (1 0) (-1 0))]
             #:when (check-bounds (+ i (first d)) (+ j (second d)))
             #:when (>= (add1 (hash-ref inp (list i j))) (hash-ref inp (list (+ i (first d)) (+ j (second d)))))
             #:unless (memf (lambda (e) 
                              (and (= (first e) (+ i (first d))) 
                                   (= (second e) (+ j (second d)))))
                            been))
            (list (+ i (first d)) (+ j (second d)))))

(define (bfs queue been)
  (match queue
    [(cons head tail)
     (match-let* ([(list i j steps) head]
                  [r (reachable i j been)]
                  [new (remove* been r)])
                 (if (equal? (list i j) end)
                   steps
                   (bfs (append tail (map (lambda (x) (append x (list (add1 steps)))) new)) 
                        (append been new))))]
    [empty 9999]))

(bfs (list (append start '(0))) '())

(for/fold ([m 9999])
          ([(key value) inp]
           #:when (= value (char->integer #\a)))
          (min m (bfs (list (append key '(0))) '())))
