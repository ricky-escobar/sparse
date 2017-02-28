#lang racket

(require "generator.rkt")
(require rackunit)

(provide parse-grammar-spec)

(define test-grammar
  ;; These top-level functions shouldn't be forbidden; so use them explicitly
  `([true false + - * / eq? <= substring]
    ;; Call the recursive rule `expr`
    [expr
     {if expr expr expr}
     ;; Wow! that `...` looks so natural!
     {expr expr ...}
     ;; Note id is wrapped in brackets 
     {with {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {new [id] expr ...}
     {send expr expr expr ...}
     {rec {[id] = expr} expr}
     ;; After `id` we provide `this`, since it's a valid id in this context
     ;; but isn't a valid param name.
     [id this]
     ;; Some example strings to use
     [U "Hello" "World" ""]
     ;; Some example numbers to use
     [U 0 1 -1 2.2 -22/7]]))

;; Parses a grammar specification like the one above into the form expected by
;; generate-testcase. `s` should be a list with two elements. The first is a
;; list of identifiers to explicitly add to the testcase. The second is the
;; actual grammar. The first element of the actual grammar is the name of the
;; recursive rule, e.g., `expr`. The rest are the rules of the grammar.
;; The form [id ids ...] is special and denotes an identifier with addition ids
;; to use.
;; The form [U literals ...] is also special and denotes a literal with
;; mutliple examples.
;; Placing a literal ... after a term denotes a variadic list.
;; Any other literal which doesn't match the name of the recursive rule
;; is treated as a literal in the grammar.
(define (parse-grammar-spec s)
  (match s
    [(list ids (list (? symbol? expr) rules ...))
     (map (parse-rule expr ids) (map desugar-... rules))]))

;; Moves a variadic pair `term ...` into a list (... term) to make parsing easier
(define (desugar-... rule)
  (match rule
    [(cons '... rest)
     (error "... not after term in ~s" rule)]
    [(list term '... rest ...)
     (cons (list '... (desugar-... term)) (desugar-... rest))]
    [(cons term rest)
     (cons (desugar-... term) (desugar-... rest))]
    [else rule]))

;; Parses a rule into the Rule<%> form of generator.rkt
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
    (U "Hello" "World" "")
    (U 0 1 -1 2.2 -22/7)))

(check-exn exn:fail? (λ () (desugar-... '(x y ... (... x) z))))
(check-equal? (desugar-... (second test-grammar)) desugared-testcase)
