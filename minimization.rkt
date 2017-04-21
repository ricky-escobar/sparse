#lang racket

(require "generator.rkt")

(provide minimal-failures rho->sexp)

;; Constructs a list of minimal failures to the student's parse function.
;; The list is empty only if the student passes the testcase, but it is not
;; meant to be "exhaustive"; fixing the identified failures does not guarantee
;; that the fixed parse function will pass the testcase. The `parse` parameter
;; should be exactly the student's parse function. `testcase` should be the
;; output of `generate-testcase`. `preprocess` is any preprocessing that
;; should be done to intermediate s-expressions to prepare them for `parse`.
;; For example, you might want to wrap it in a pair of braces if `parse` is
;; actually `parse-prog`.
;; ((Sexp -> Any) rho (Sexp -> Sexp) -> (Listof Sexp))
(define (minimal-failures parse testcase preprocess)
  (define (wrapped-parse s)
    (with-handlers ([exn:fail? (λ (e) #f)]) (parse (preprocess s)) #t))
  (remove-duplicates (map rho->sexp (map (trim-bottom wrapped-parse 1) ((trim-top wrapped-parse) testcase)))))

;; Returns terms for which `func` returns false, but `func` on each subterm
;; returns true.
(define ((trim-top func) r)
  (match r
    [(rho e) 
     (cond
       [(func (rho->sexp r)) empty]
       [(list? e)
        (define bad-subs (flatten (map (trim-top func) e)))
        (if (empty? bad-subs)
            (list r)
            bad-subs)]
       [else (list r)])]
    [else
     (cond
       [(list? r) (map (trim-top func) r)]
       [else empty])]))

;; Prunes as much off the failing tree as possible, but not pruning so much
;; that it passes.
(define ((trim-bottom func depth) r)
  (define truncd ((trunc depth) r))
  (cond
    [(equal? r truncd) r]
    [(func (rho->sexp truncd))
         ((trim-bottom func (+ 1 depth)) r)]
    [else truncd]))

;; Replaces all subtrees beyond a certain depth with the identifier 'x.
(define ((trunc depth) r)
  (match r
    [(rho (list e ...)) (if (positive? depth) (rho (map (trunc (- depth 1)) e)) (rho 'x))]
    [(rho _) r]
    [(list s ...) (map (trunc depth) s)]
    [else r]))
