#lang racket

(require "generator.rkt")
(require "parse-grammar-spec.rkt")
(require "minimization.rkt")

(provide (all-defined-out))

;; (Sexp -> Sexp)
(define (generate-valid-testcase grammar)
  (rho->sexp (generate-testcase (parse-grammar-spec grammar))))

;; (Sexp -> (Listof Sexp))
(define (generate-invalid-testcases grammar)
  (generate-bad-testcases (parse-grammar-spec grammar)))

;; (Sexp -> AnnotatedSexp)
(define (generate-valid-testcase-for-minimization grammar)
  (generate-testcase (parse-grammar-spec grammar)))

;; (AnnotatedSexp (Sexp -> Any) (Sexp -> Sexp) -> (Listof Sexp))
(define (produce-minimum-failing-testcases minimization-testcase parse-function-to-test preprocess)
  (map preprocess (minimal-failures parse-function-to-test minimization-testcase preprocess)))

;; (AnnotatedSexp -> Sexp)
(define (strip-minimization-info minimization-testcase)
  (rho->sexp minimization-testcase))