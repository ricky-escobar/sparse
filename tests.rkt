#lang racket

(require "test-runner.rkt")

(define phym5-grammar
  `([true false + - * / eq? <= substring]
    [lam new send = var rec if]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {var {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {new [id] expr ...}
     {send expr expr expr ...}
     {rec {[id] = expr} expr}
     [id this]
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program5"
 'parse-prog
 phym5-grammar
 (λ (s) `{,s}))
