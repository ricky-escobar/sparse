# Testcase generation and minimization for John Clements's CPE 430

The idea is to take in a description of the syntax of the language that the students are implementing and produce a big testcase that makes sure that students parse valid expressions without throwing an error.

For example, given the EBNF-like grammar:
```
`[[true false + - * / eq? <= substring]
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
     [number 0 1 -1 2.2 -22/7]]]
```
         
 the following testcase is generated:

```
{if {lam {} {lam {} {new e {lam {} {{lam {} {var {d = {lam {} {rec {i = {lam {}
{if {new d {new c {{new b {var {a = {new a {rec {h = {new substring {if {{{var
{<= = {{rec {g = {{if {var {eq? = {var {/ = {rec {f = {var {* = {if {rec {e =
{rec {d = {if {if {send {lam {} {send {new <= {send {{send {var {- = {send {rec
{c = {send {if this {lam {true false + -} true} {lam {* / eq?} "Hello"}} {lam
{<= substring} 0} {new true false} {+ {new false "World"} {"" {var {true = -}
{new + 1}} {rec {true = *} {-1 {if "Hello" {substring {send {send / {{{{eq?
{lam {a} {var {false = ""} {var {+ = -22/7} {rec {false = "Hello"} {var {if 0
{var {send "World" {var <=} {var ""} {rec {+ = 1} {rec {b = -} {if + {rec {a
= true} {send -1 {rec {- = {var 2.2}} substring} {if z {if x {send v {if u a
{var {lam {} {var {{rec {* = {rec {/ = {rec {substring = t} {lam {} {rec {eq?
= {if s "World" {if r 0 {send q {send p b {send {if {if {if {if {if k l {{if i
j {rec {<= = {send {send {send f g {lam {} e}} {new eq?} 2.2} -1 "World"}} h}}}}
m {new /}} n 1} o "Hello"} {new *} d} "" c}}}}}} {new -}}}}} -22/7}} "Hello"}}}}}}}
w} y} this}} false}}} *}} /}}}}}}} 2.2} "World"} eq?}} <=}} a} b}} c} d e} f g}} h}
i}} j} k}} l}} m}} n} o p} q r}} s}} t} u v}} w}} x}} y}} z} this true}}} false}}}
{substring = +} -}}} * /}}} eq?}}} {b = <=} {c = substring} a}}} b} c d} e f}}} g}}}
{e = h} {f = i} {g = j} k}}}} l m n}}} o p}
```

Wow! That's a mouthful! If a student were to fail that testcase, how would they even know where to begin? It would be nice to produce a minimal failing testcase that shows more simply what the student's error is.

By dynamically calling the student's parser with narrower and narrower tests, we can do just that. For example, the above testcase yields the following minimal failures for one student:

```
{lam {true false + -} true}
{lam {* / eq?} "Hello"}
{lam {<= substring} 0}
{rec {- = x} substring}
{rec {<= = x} h}
```

## Generating syntactically-invalid testcases

Using some of the machinery developed for generating *valid* testcases, we can also generate syntactically-*invalid* testcases to verify that students properly throw an error message for syntactically-invalid programs. Here are the testcases generated for the above grammar:

```
{lam q r s}
{if lam "" "Hello"}
{if -22/7 lam 0}
{if t u lam}
{}
{if}
{if "World"}
{if 1 ""}
{if -22/7 "" x "Hello"}
{if y 0 1 z "World"}
{if "" this -1 true "Hello" 2.2}
{"World" new}
{lam {h = substring} a}
{var {lam = "World"} "Hello"}
{var {i lam 0} 0}
{var {j = send} e}
{var {} "World"}
{var {k} 1}
{var {l =} f}
{var {o = b "Hello"} g}
{var {p = -1 c "World"} "Hello"}
{var {q = 2.2 d "" -22/7} 2.2}
{var {r = h} =}
{var}
{var {s = "World"}}
{var {v = "Hello"} j "World"}
{var {w = 1} -1 k ""}
{var {x = l} 2.2 m "Hello" -22/7}
{new {b} n}
{lam {lam} "World"}
{lam {n} new}
{lam}
{lam {o}}
{lam {r} -1 r}
{lam {s} "" 2.2 s}
{lam {t} "Hello" -22/7 t "World"}
{lam f u} {new lam ""}
{new g send}
{new}
{lam z this true}
{send send "World" ""}
{send 2.2 = -22/7}
{send false + var}
{send}
{send "Hello"}
{lam {j = b} c}
{rec {lam = "Hello"} ""}
{rec {k lam 2.2} 2.2}
{rec {l = rec} g}
{rec {} "Hello"}
{rec {m} -22/7}
{rec {n =} h}
{rec {q = d ""} i}
{rec {r = 0 e "Hello"} ""}
{rec {s = 1 f "World" -1} 1}
{rec {t = j} if}
{rec}
{rec {u = "Hello"}}
{rec {x = ""} l "Hello"}
{rec {y = -22/7} 0 m "World"}
{rec {z = n} 1 o "" -1}
lam
=
var
```

## What's next?

The above tests should test students' parsers pretty thoroughly. Next, we can try to generate testcases for their interpreter. The main challenge associated with this is that, in order to generate good *semantically-valid* testcases, we must of knowledge of language's type system and how it binds identifiers.
