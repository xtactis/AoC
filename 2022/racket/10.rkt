#lang racket

(require threading)

(define input (map string-split (sequence->list (in-lines))))

(define (calcX i X)
  (if (= (modulo i 40) 20)
    (* i X)
    0))

(define (draw i X screen)
  (if (<= (- X 1) (modulo (sub1 i) 40) (+ X 1))
    "#"
    "."))

(define (drawscreen screen)
  (when (non-empty-string? screen)
    (printf "~a\n" (substring screen 0 40))
    (drawscreen (substring screen 40))))

(define (solve cmds X i screen)
  (define newscreen (string-append screen (draw i X screen)))
  (+ (calcX i X) 
     (if (empty? cmds)
       (begin 
         (drawscreen screen)
         0)
       (case (caar cmds)
         [("addx2") (solve (rest cmds) (+ X (cadar cmds)) (add1 i) newscreen)]
         [("addx") (solve (list* (list "addx2" (string->number (cadar cmds))) (rest cmds)) X (add1 i) newscreen)]
         [("noop") (solve (rest cmds) X (add1 i) newscreen)]))))

(solve input 1 1 "")


