#lang racket

(define (read-next-line-iter file)
        (let ((line (read-line file 'any)))
	     (if (not (eof-object? line))
	         (append (list line) (read-next-line-iter file))
	         '())))

(define raw-input (call-with-input-file "02.in" read-next-line-iter))
(define rps-input (map (lambda (line) 
			 (map (lambda (char) 
				(case char [("A" "X") 1] [("B" "Y") 2] [("C" "Z") 3])) 
			      (string-split line))) 
		       raw-input))

(define (rotate lst n)
  (append (drop lst n) (take lst n)))

(define (rotate-right lst n)
  (append (take-right lst n) (drop-right lst n)))

(define (part-1 game)
  (let ([player-1 (first game)] [player-2 (second game)])
	(+ player-2 (last (take (rotate-right (list 6 0 3) player-1) player-2)))))

(define (part-2 game)
  (let ([player-1 (first game)] [outcome (second game)]) 
       (+ (* 3 (- outcome 1)) (last (take (rotate (list 2 3 1) player-1) outcome)))))

(printf "Part 1: ~a\nPart 2: ~a\n"
        (apply + (map part-1 rps-input))
        (apply + (map part-2 rps-input)))

#|1 2 3
  R P S
R 3 6 0
P 0 3 6
S 6 0 3 

  1 2 3
1 3 1 2
2 1 2 3
3 2 3 1 |#
