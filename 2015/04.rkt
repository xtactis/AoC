#lang racket

(require file/md5)

(define raw-input (first (sequence->list (in-lines))))

(define (search-for-hash iterator prefix)
    (if (string-prefix? (bytes->string/utf-8 (md5 (~a raw-input iterator))) prefix)
        iterator
        (search-for-hash (+ iterator 1) prefix)))

(printf "Part 1: ~a\nPart 2: ~a\n" (search-for-hash 0 "00000") (search-for-hash 0 "000000"))

