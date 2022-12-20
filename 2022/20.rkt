#lang racket

(require threading)

(define input (for/list ([line (in-lines)]
                         [id (in-naturals)])
                        (list id (string->number line))))

(define (insert l idx value)
  (append (list value) (drop l idx) (take l idx)))

(define (1-iteration l idx n)
  (define i (index-where l (lambda (arg)
                             (= (first arg) idx))))
  (match-define (list id e) (list-ref l i))
  (insert (rest (append (drop l i) (take l i))) 
          (modulo e (sub1 n))
          (list id e)))

(define (actually-solve _l key iterations n)
  (define l (for/list ([el _l])
                      (list (first el) (* (second el) key))))
  (for/fold ([curl l])
            ([_ (in-range iterations)])
            (for/fold ([curll curl])
                      ([idx (in-range n)])
                      (1-iteration curll idx n))))

(define (solve l key iterations)
  (define n (length l))
  (define solved (actually-solve l key iterations n))
  (define idx-of-zero (index-where solved
                        (lambda (arg) (= (second arg) 0))))
  (define rotated (append (drop solved idx-of-zero) (take solved idx-of-zero)))
  (+ (second (list-ref rotated (modulo 1000 n)))
     (second (list-ref rotated (modulo 2000 n)))
     (second (list-ref rotated (modulo 3000 n)))))

(solve input 1 1)
(solve input 811589153 10)



