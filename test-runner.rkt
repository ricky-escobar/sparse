#lang racket
(require "minimization.rkt")
(provide run-tests)

(define (sexps->string sexps)
  (string-replace (string-replace (apply ~s sexps) "(" "{") ")" "}"))

(define (run-tests dir func-to-test testcase preprocess-testcase)
  (define old-dir (current-directory))
  (current-directory dir)
  (define out (open-output-file "results.txt" #:mode 'text #:exists 'truncate))

  (define ((parse-wrapper parse) s)
    (with-handlers ([exn:fail? (λ (e) #f)]) (begin (parse (preprocess-testcase s)) #t)))

  (define (grade-progs dirs)
    (for ([dir dirs])
      (display (string-append (path->string dir) " ") out)
      (if (file-exists? (build-path dir "success-attempt"))
          (displayln "success-attempt" out)
          (with-handlers ([exn:fail? (λ (e) (displayln "invalid module" out))])
            (display (if (file-exists? (build-path dir "fail")) "[fail] " "[pass] ") out)
            (define parse (dynamic-require (build-path dir "text1.rkt") func-to-test))
            (define msg (sexps->string (minimal-failures (parse-wrapper parse) testcase)))
            (displayln msg)
            (displayln msg out)))))

  (grade-progs (filter directory-exists? (directory-list)))

  (close-output-port out)
  (current-directory old-dir))