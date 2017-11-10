#lang racket

(require "generator.rkt")
(require "parse-grammar-spec.rkt")
(require "minimization.rkt")
(require rackunit)

(provide (all-defined-out))

;; (Sexp (Sexp -> Any) [String] [(Sexp -> Sexp)] -> Void)
(define test-parse
  (λ (grammar parse [lang-name ""] [preprocess identity])
    (define failing-valid-testcases (produce-minimum-failing-testcases
                                     (generate-valid-testcase-for-minimization grammar) parse preprocess))
    (define failing-invalid-testcases
      (filter (λ (testcase)
                (with-handlers ([exn:fail? (λ (e) (not (string-contains? (exn-message e) lang-name)))])
                  (parse (preprocess testcase)))) (generate-invalid-testcases grammar)))
    (unless (empty? failing-valid-testcases)
      (fail (string-append "The following programs are syntactically valid, but were not parsed successfully: "
                           (string-join (map ~s failing-valid-testcases) ", "))))
    (unless (empty? failing-invalid-testcases)
      (fail (string-append "The following programs are syntactically invalid, but did not throw an exception containing " lang-name ": "
                           (string-join (map ~s failing-invalid-testcases) ", "))))))

;; (Sexp -> Sexp)
(define (generate-valid-testcase grammar)
  (rho->sexp (generate-testcase (parse-grammar-spec grammar))))

;; (Sexp -> (Listof Sexp))
(define (generate-invalid-testcases grammar)
  (generate-bad-testcases (parse-grammar-spec grammar)))

;; (Sexp -> AnnotatedSexp)
(define (generate-valid-testcase-for-minimization grammar)
  (generate-testcase (parse-grammar-spec grammar)))

;; (AnnotatedSexp (Sexp -> Any) [(Sexp -> Sexp)] -> (Listof Sexp))
(define produce-minimum-failing-testcases
  (λ (minimization-testcase parse-function-to-test [preprocess identity])
    (map preprocess (minimal-failures parse-function-to-test minimization-testcase preprocess))))

;; (Sexp Sexp -> Boolean)
(define (conforms-to-grammar? grammar expression)
  (conforms-to-rules? (parse-grammar-spec grammar) expression))

;; (AnnotatedSexp -> Sexp)
(define (strip-minimization-info minimization-testcase)
  (rho->sexp minimization-testcase))