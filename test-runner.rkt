#lang racket

(require "minimization.rkt")
(require "generator.rkt")
(require "parse-grammar-spec.rkt")

(provide run-tests)

(define (disp msg port)
  (display msg)
  (display msg port))

(define (displn msg port)
  (displayln msg)
  (displayln msg port))

(define (sexps->string sexps)
  (string-replace (string-replace (apply ~s sexps) "(" "{") ")" "}"))

(define ((doesnt-error-cleanly? func msg preprocess) arg)
  (with-handlers ([exn:fail? (λ (e) (not (string-contains? (exn-message e) msg)))])
    (func (preprocess arg))))

;; Tests the submissions in dir with the grammar
(define (run-tests dir func-to-test grammar preprocess)
  (define old-dir (current-directory))
  (current-directory dir)
  (define out (open-output-file "results2.txt" #:mode 'text #:exists 'truncate))

  (define rules (parse-grammar-spec grammar))

  (define testcase (generate-testcase rules))
  (define bad-syntax-testcases (generate-bad-testcases rules))

  (displayln (sexps->string (list (rho->sexp testcase))))
  (displayln (sexps->string bad-syntax-testcases))

  (define (grade-progs dirs)
    (for ([dir dirs])
      (disp (string-append (path->string dir) " ") out)
      (if (file-exists? (build-path dir "success-attempt"))
          (displn "success-attempt" out)
          (with-handlers ([exn:fail? (λ (e) (displn "invalid module" out))])
            (disp (if (file-exists? (build-path dir "fail")) "[fail] " "[pass] ") out)
            (define parse (dynamic-require (build-path dir "text1.rkt") func-to-test))
            (define msg (sexps->string (minimal-failures parse testcase preprocess)))
            (disp msg out)
            (define didnt-error (filter (doesnt-error-cleanly? parse "PHYM" preprocess) bad-syntax-testcases))
            (disp " --- " out)
            (displn (sexps->string didnt-error) out)))))

  (grade-progs (filter directory-exists? (directory-list)))

  (close-output-port out)
  (current-directory old-dir))