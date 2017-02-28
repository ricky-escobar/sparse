#lang racket

(require "minimization.rkt")
(require "generator.rkt")
(require "parse-grammar-spec.rkt")

(provide run-tests)

(define (sexps->string sexps)
  (string-replace (string-replace (apply ~s sexps) "(" "{") ")" "}"))

;; Tests the submissions in dir with the grammar
(define (run-tests dir func-to-test grammar preprocess)
  (define old-dir (current-directory))
  (current-directory dir)
  (define out (open-output-file "results.txt" #:mode 'text #:exists 'truncate))

  (define testcase (generate-testcase (parse-grammar-spec grammar)))

  (displayln (rho->sexp testcase))
  
  (define (grade-progs dirs)
    (for ([dir dirs])
      (display (string-append (path->string dir) " ") out)
      (if (file-exists? (build-path dir "success-attempt"))
          (displayln "success-attempt" out)
          (with-handlers ([exn:fail? (λ (e) (displayln "invalid module" out))])
            (display (if (file-exists? (build-path dir "fail")) "[fail] " "[pass] ") out)
            (define parse (dynamic-require (build-path dir "text1.rkt") func-to-test))
            (define msg (sexps->string (minimal-failures parse testcase preprocess)))
            (displayln msg)
            (displayln msg out)))))

  (grade-progs (filter directory-exists? (directory-list)))

  (close-output-port out)
  (current-directory old-dir))
