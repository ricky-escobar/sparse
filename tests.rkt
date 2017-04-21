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

(define phym4-grammar
  `([true false null + - * / eq? <= substring array new-array aref aset! begin substring]
    [lam = var if]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {var {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     [id]
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define phym3-grammar
  `[[foo]
    [true false var if lam + - * / eq? <=]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {var {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {[U + - * eq? <=] expr expr}
     {/ expr expr}
     [id]
     true
     false
     [number 1 01 2.2 -22/7]
     0]])

(define phym2-grammar
  `[[foo]
    [+ - * / ifleq0]
    [expr
     {ifleq0 expr expr expr}
     {[id] expr ...}
     {+ expr expr}
     {- expr expr}
     {* expr expr}
     {/ expr expr}
     [id]
     [number 1 01 2.2 -22/7]
     0]])

(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program2"
 'parse
 phym2-grammar
 (λ (s) s))

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program3"
 'parse
 phym3-grammar
 (λ (s) s))

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program4"
 'parse
 phym4-grammar
 (λ (s) s))

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program5"
 'parse-prog
 phym5-grammar
 (λ (s) `{,s}))
