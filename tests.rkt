#lang racket

(require "test-runner.rkt")

(define dfly5-grammar
  `([true false + - * / eq? <= substring]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {new [id] expr ...}
     {send expr expr expr ...}
     {rec {[id] = expr} expr}
     [id this]
     [U "Hello" "World" ""]
     [U 0 1 -1 2.2 -22/7]]))

(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2164-cpe430\\handin\\Program5"
 'parse-prog
 dfly5-grammar
 (λ (s) `{,s}))
