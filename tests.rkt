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
  `([foo]
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
  `([foo]
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
  `([foo]
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
  `([foo]
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
     [number 1 -1 2.2 -22/7]
     0]])

(define dfly3-grammar
  `[[foo]
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
  `[[foo]
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
  `[[foo]
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
     [number 1 -1 2.2 -22/7]
     0]])

(define dfly2-grammar
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
     [number 1 -1 2.2 -22/7]
     0]])

(define owqq2-grammar
  `[[foo]
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
  `[[foo]
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

(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2158-cpe430\\handin\\Program5"
 'parse
 looi5-grammar
 (λ (s) `{,s})
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2158-cpe430\\handin\\Program4"
 'parse
 looi4-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2158-cpe430\\handin\\Program3"
 'parse
 looi3-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2158-cpe430\\handin\\Program2"
 'parse
 looi2-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2162-cpe430\\handin\\Program5"
 'parse
 owqq5-grammar
 (λ (s) `{,s})
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2162-cpe430\\handin\\Program4"
 'parse
 owqq4-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2162-cpe430\\handin\\Program3"
 'parse
 owqq3-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2162-cpe430\\handin\\Program2"
 'parse
 owqq2-grammar
 (λ (s) s)
 "")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2164-cpe430\\handin\\Program2"
 'parse
 dfly2-grammar
 (λ (s) s)
 "DFLY")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2164-cpe430\\handin\\Program3"
 'parse
 dfly3-grammar
 (λ (s) s)
 "DFLY")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2164-cpe430\\handin\\Program4"
 'parse
 dfly4-grammar
 (λ (s) s)
 "DFLY")

#;(run-tests
 "C:\\Users\\Ricky\\Desktop\\Classes\\senior-project\\old-430-submissions\\2164-cpe430\\handin\\Program5"
 'parse-prog
 dfly5-grammar
 (λ (s) `{,s})
 "DFLY")

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program2"
 'parse
 phym2-grammar
 (λ (s) s)
 "PHYM")

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program3"
 'parse
 phym3-grammar
 (λ (s) s)
 "PHYM")

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program4"
 'parse
 phym4-grammar
 (λ (s) s)
 "PHYM")

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program5"
 'parse-prog
 phym5-grammar
 (λ (s) `{,s})
 "PHYM")
