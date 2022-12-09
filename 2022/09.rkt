#lang racket

(require threading)

(define input (for/list ([cmd (in-lines)])
                        (define tmp (string-split cmd))
                        (list (first tmp) (string->number (second tmp)))))
(define cmds (flatten (for/list ([cmd input])
                                (for/list ([_ (in-range (second cmd))])
                                          (first cmd)))))

(define (move-first cmd head)
  (case cmd
    [("U") (list (first head) (add1 (second head)))]
    [("D") (list (first head) (sub1 (second head)))]
    [("L") (list (sub1 (first head)) (second head))]
    [("R") (list (add1 (first head)) (second head))]))

(define (hyp a b)
  (sqrt (+ (* a a) (* b b))))

(define (propagate H T)
  (define-values (Hx Hy Tx Ty) (values (first H) (second H) (first T) (second T)))
  (define-values (dx dy) (values (- Hx Tx) (- Hy Ty)))
  (define dist (hyp dx dy))
  (if (>= (hyp dx dy) 2)
    (list (+ Tx (sgn dx)) (+ Ty (sgn dy)))
    T))

(define (step cmd chain [prev #f])
  (if (empty? chain)
    '()
    (if prev
      (let ([lead (propagate prev (first chain))])
        (append (list lead) (step cmd (rest chain) lead)))
      (let ([lead (move-first cmd (first chain))])
        (append (list lead) (step cmd (rest chain) lead))))))

(define (solve cmds chain)
  (if (empty? cmds)
    '()
    (let ([newchain (step (first cmds) chain)])
      (append (list newchain) (solve (rest cmds) newchain)))))

(~>> '((0 0) (0 0))
     (solve cmds)
     (map last)
     remove-duplicates
     length)
            
(~>> '((0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0) (0 0))
     (solve cmds)
     (map last)
     remove-duplicates
     length)
