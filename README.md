# Testcase generation and minimization for John Clements's CPE 430

The idea is to take in a description of the syntax of the language that the students are implementing and produce a big testcase that makes sure that students parse valid expressions without throwing an error.

For example, given the EBNF-like grammar:
```
 `[[true false + - * / eq? <= substring]
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
     [U 0 1 -1 2.2 -22/7]]]
```
         
 the following testcase is generated:

```
{if {lam {} {lam {} {new e {lam {} {{lam {} {with {d = {lam {}
{rec {i = {lam {} {if {new d {new c {{new b {with {a = {new a
{rec {h = {new substring {if {{{with {<= = {{rec {g = {{if
{with {eq? = {with {/ = {rec {f = {with {* = {if {rec {e =
{rec {d = {if {if {send {lam {} {send {new <= {send {{send
{with {- = {send {rec {c = {send {if this {lam {true false + -}
true} {lam {* / eq?} Hello}} {lam {<= substring} 0} {new true
false} {+ {new false World} {{with {true = -} {new + 1}} {rec
{true = *} {-1 {if Hello {substring {send {send / {{{{eq? {lam
{a} {with {false =} {with {+ = -22/7} {rec {false = Hello} {with
{if 0 {with {send World {with <=} {with} {rec {+ = 1} {rec {b =
-} {if + {rec {a = true} {send -1 {rec {- = {with 2.2}} substring}
{if z {if x {send v {if u a {with {lam {} {with {{rec {* = {rec {/
= {rec {substring = t} {lam {} {rec {eq? = {if s World {if r 0
{send q {send p b {send {if {if {if {if {if k l {{if i j {rec {<=
= {send {send {send f g {lam {} e}} {new eq?} 2.2} -1 World}} h
}}}} m {new /}} n 1} o Hello} {new *} d} c}}}}}} {new -}}}}}
-22/7}} Hello}}}}}}} w} y} this}} false}}} *}} /}}}}}}} 2.2} World}
eq?}} <=}} a} b}} c} d e} f g}} h} i}} j} k}} l}} m}} n} o p} q r}}
s}} t} u v}} w}} x}} y}} z} this true}}} false}}} {substring = +} -}
}} * /}}} eq?}}} {b = <=} {c = substring} a}}} b} c d} e f}}} g}}}
{e = h} {f = i} {g = j} k}}}} l m n}}} o p}
```

Wow! That's a mouthful! If a student were to fail that testcase, how would they even know where to begin? It would be nice to produce a minimal failing testcase that shows more simply what the student's error is.

By dynamically calling the student's parser with narrower and narrower tests, we can do just that. For example, the above testcase yields the following minimal failures for one student:

```
{lam {true false + -} true}
{lam {* / eq?} "Hello"}
{lam {<= substring} 0}
{-1 x b}
```

## What's next?

Using some of the machinery developed for generating *valid* testcases, we can try generating *invalid* testcases to verify that students properly throw an error message for syntactically-invalid programs.
