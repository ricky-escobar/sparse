#lang racket

(require "generator.rkt")
(require rackunit)

(define testcase
  `([true false + - * / eq? <= substring]
    [expr {if expr expr expr}
          {expr expr ...}
          {with {[id] = expr} ... expr}
          {lam {[id] ...} expr}
          {new [id] expr ...}
          {send expr expr expr ...}
          {rec {[id] = expr} expr}
          [id this]
          [U "Hello" "World"]
          [U 1 -1 2.2 -22/7]
          0]))

(define desugared-testcase
  '(expr
    (if expr expr expr)
    (expr (... expr))
    (with (... ((id) = expr)) expr)
    (lam ((... (id))) expr)
    (new (id) (... expr))
    (send expr expr (... expr))
    (rec ((id) = expr) expr)
    (id this)
    (U "Hello" "World")
    (U 1 -1 2.2 -22/7)
    0))

(define (parse-grammar-spec s)
  (match s
    [(list ids (list (? symbol? expr) rules ...))
     (map (parse-rule expr ids) (map desugar-... rules))]))

(define (desugar-... rule)
  (match rule
    [(cons '... rest)
     (error "... not after term in ~s" rule)]
    [(list term '... rest ...)
     (cons (list '... (desugar-... term)) (desugar-... rest))]
    [(cons term rest)
     (cons (desugar-... term) (desugar-... rest))]
    [else rule]))

(check-exn exn:fail? (λ () (desugar-... '(x y ... (... x) z))))
(check-equal? (desugar-... (second testcase)) desugared-testcase)

(define ((parse-rule expr ids) rule)
  (match rule
    [(? (λ (s) (equal? s expr)))
     (new Recursive%)]
    [(list '... term)
     (new Variadic% [repeated-term ((parse-rule expr ids) term)])]
    [(list 'U terms ...)
     (new Literal% [the-examples terms])]
    [(list 'id other-ids ...)
     (new Identifier% [ids (append other-ids ids)])]
    [(list subterms ...)
     (new List% [subterms (map (parse-rule expr ids) subterms)])]
    [sym
     (new Literal% [the-examples (list sym)])]))

(generate-testcase (parse-grammar-spec testcase))
