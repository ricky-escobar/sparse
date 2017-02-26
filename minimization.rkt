#lang racket

(struct rho (e) #:transparent)

(define (parse-rho r)
  (match r
    [(list 'ρ rest) (rho (parse-rho rest))]
    [(? list? l) (map parse-rho l)]
    [else r]))

(define (rho->sexp r)
  (match r
    [(rho e) (rho->sexp e)]
    [(? list? l) (map rho->sexp l)]
    [else r]))

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

(define ((trim-bottom func depth) r)
  (define truncd ((trunc depth) r))
  (cond
    [(equal? r truncd) r]
    [(func (rho->sexp truncd))
         ((trim-bottom func (+ 1 depth)) r)]
    [else truncd]))

(define ((trunc depth) r)
  (match r
    [(rho (list e ...)) (if (positive? depth) (rho (map (trunc (- depth 1)) e)) (rho 'x))]
    [(rho _) r]
    [(list s ...) (map (trunc depth) s)]
    [else r]))

(define (minimal-failures func s)
  (remove-duplicates (map rho->sexp (map (trim-bottom func 1) ((trim-top func) (parse-rho s))))))

(provide minimal-failures)