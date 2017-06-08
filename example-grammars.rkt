#lang racket

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

(define dfly5-grammar
  `([true false + - * / eq? <= substring]
    [lam new send = with rec if]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {new [id] expr ...}
     {send expr expr expr ...}
     {rec {[id] = expr} expr}
     [id this]
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define owqq5-grammar
  `([]
    [true false with if func = rec new send class extends + - * / eq? <=]
    [expr
     {rec {[id] = expr} expr}
     {new [id] expr ...}
     {send expr [id] expr ...}
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func {[id] ...} expr}
     {[U + - * / eq? <=] expr expr}
     [id]
     true
     false
     this
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define looi5-grammar
  `([]
    [true false with if func = rec new send class extends + - * / eq? <=]
    [expr
     {rec {[id] = expr} expr}
     {new [id] expr ...}
     {send expr [id] expr ...}
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func [id] ... expr}
     {[U + - * / eq? <=] expr expr}
     [id]
     true
     false
     this
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define phym4-grammar
  `([true false null + - * / eq? <= substring array new-array aref aset! begin]
    [lam = var if]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {var {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     [id]
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define dfly4-grammar
  `([true false null + - * / eq? <= substring array new-array aref aset! begin substring]
    [lam = with if]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     [id]
     [string "Hello" "World" ""]
     [number 0 1 -1 2.2 -22/7]]))

(define owqq4-grammar
  `([]
    [true false with if func new-array array ref = <- begin + - * / eq? <=]
    [expr
     {new-array expr expr}
     {array expr expr ...}
     {ref expr {expr}}
     {expr {expr} <- expr}
     {[id] <- expr}
     {begin expr expr ...}
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func {[id] ...} expr}
     {[U + - * / eq? <=] expr expr}
     [id]
     true
     false
     [number 0 1 -1 2.2 -22/7]]))

(define looi4-grammar
  `([]
    [true false with if func new-array = <- begin + - * / eq? <=]
    [expr
     {new-array expr expr}
     {array expr ...}
     {ref expr {expr}}
     {expr {expr} <- expr}
     {[id] <- expr}
     {begin expr expr ...}
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func [id] ... expr}
     {[U + - * / eq? <=] expr expr}
     [id]
     true
     false
     [number 0 1 -1 2.2 -22/7]]))

(define phym3-grammar
  `[[]
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
     [number 1 -1 2.2 -22/7]
     0]])

(define dfly3-grammar
  `[[]
    [true false with if lam + - * / eq? <=]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {lam {[id] ...} expr}
     {[U + - * eq? <=] expr expr}
     {/ expr expr}
     [id]
     true
     false
     [number 1 -1 2.2 -22/7]
     0]])

(define owqq3-grammar
  `[[]
    [true false with if func + - * / eq? <=]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func {[id] ...} expr}
     {[U + - * eq? <=] expr expr}
     {/ expr expr}
     [id]
     true
     false
     [number 1 -1 2.2 -22/7]
     0]])

(define looi3-grammar
  `[[]
    [true false with if func + - * / eq? <=]
    [expr
     {if expr expr expr}
     {expr expr ...}
     {with {[id] = expr} ... expr}
     {func [id] ... expr}
     {[U + - * eq? <=] expr expr}
     {/ expr expr}
     [id]
     true
     false
     [number 1 -1 2.2 -22/7]
     0]])

(define phym2-grammar
  `[[]
    [+ - * / ifleq0]
    [expr
     {ifleq0 expr expr expr}
     {[id] expr ...}
     {+ expr expr}
     {- expr expr}
     {* expr expr}
     {/ expr expr}
     [id]
     [number 1 -1 2.2 -22/7]
     0]])

(define dfly2-grammar
  `[[]
    [+ - * / ifleq0]
    [expr
     {ifleq0 expr expr expr}
     {[id] expr ...}
     {+ expr expr}
     {- expr expr}
     {* expr expr}
     {/ expr expr}
     [id]
     [number 1 -1 2.2 -22/7]
     0]])

(define owqq2-grammar
  `[[]
    [+ - * / func ifleq0]
    [expr
     {ifleq0 expr expr expr}
     {[id] expr ...}
     {+ expr expr}
     {- expr expr}
     {* expr expr}
     {/ expr expr}
     [id]
     [number 1 -1 2.2 -22/7]
     0]])

(define looi2-grammar
  `[[]
    [+ - * / func ifleq0]
    [expr
     {ifleq0 expr expr expr}
     {[id] :D expr ...}
     {+ expr expr}
     {- expr expr}
     {* expr expr}
     {/ expr expr}
     [id]
     [number 1 -1 2.2 -22/7]
     0]])
