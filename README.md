# Sparse: Test Generation for Simple S-expression Language Parsers

Sparse is a tool (written in Racket) for generating test cases for parsers for simple S-expression languages. It is intended primarily for use by instructors of Programming Languages classes in which students implement a simple S-expression-based programming language. It takes as input a description of the grammar of the language to be implemented and produces test cases for the students' parsers.

## Motivation

Producing test cases for parsers by hand is tedious and difficult to do exhaustively. In addition, it is likely that students will have to implement several different versions of the language, in which case several different sets of test cases must be maintained. Furthermore, if any changes to the language are made from term to term, the test cases must be updated--and doing so may not always be a simple find-and-replace. It would be nice to have a tool which automatically generates exhaustive test cases based solely on the language's grammar. This is exactly what Sparse does.

## Example

Consider the following grammar for a simple language (dubbed PHYM4) which has conditionals, local variable binding, lambdas, function applications, numbers, strings, and identifiers:

    Expr = {if Expr Expr Expr}
         | {var {Id = Expr} ... Expr}
         | {lam {Id ...} Expr}
         | {Expr Expr ...}
         | Number
         | String
         | Id

Here, `Number`, `String`, and `Id` are not to be taken literally, but rather as placeholders for literal numbers, strings, and identifiers. Additionally, `if`, `var`, `lam`, and `=` are to be forbidden as identifiers. Built-in operations, functions, and constants like `+`, `*`, `<=`, `substring`, or `true` are treated like any other identifier from the point of view of this language and so are not treated specially by the grammar.  An example program from this language is

`{{lam {x y} {if {<= x y} x y}} 5 4}`,

which introduces a function to determine the minimum of two numbers, and then applies it to 5 and 4. Note, that we use braces as delimiters instead of parentheses to distinguish this tiny language from Racket. This language is very simple, and yet writing a suite of input programs to test students' parsers would be tedious--and would likely fail to be comprehensive.

Sparse takes as input a description of the grammar which is not unlike the grammar shown above. It is worth noting here the largest limitation of Sparse. Sparse's input grammar may only have one nonterminal. In this example, this is `Expr`. For languages whose grammars have more than one nonterminal, this can be worked around by only generating test cases for the core expression grammar, which is more likely to be able to be expressed as a grammar with one nonterminal, and leaving the full language to be tested with manually-written tests.

    (define phym4-grammar
      '([true false null + - * / eq? <= substring array new-array aref aset! begin]
        [lam = var if]
        [Expr
         {if Expr Expr Expr}
         {Expr Expr ...}
         {var {[id] = Expr} ... Expr}
         {lam {[id] ...} Expr}
         [id]
         [string "Hello" "World" ""]
         [number 0 1 -1 2.2 -22/7]]))

The details of the format of the input grammar are described below. Using this grammar, one can call `generate-valid-testcase` to generate one large test case which will test to make sure the student's parser accepts all valid programs. The following is produced for the grammar defined above:

    {if {lam {} {lam {} {{lam {} {var {substring = {lam {} {if {{{var {/ = {{if {var {- =
     {var {+ = {if {if true {lam {true false null +} false} {lam {- * /} "Hello"}} {null
     {lam {eq? <=} 0} {"World" {var {true = +} {1 {if "" {var {false = "Hello"} {var {null
     = -1} {if 2.2 {if {var ""} - {{{{var /} -22/7} "World"} *}} {var 0}}}} {if {var {lam
     {substring} {if {if <= substring -1} 1 "World"}}} "Hello" eq?}} array}} new-array aref}
     aset! begin} a}} b}} {* = c} d} e f}}} {eq? = g} {<= = h} i}}} j k}}} {array = l}
     {new-array = m} {aref = n} o}}}}} p q}

Additionally, one can call `generate-invalid-testcases` to generate a list of test cases which do *not* conform to the grammar to make sure that the student's parser rejects all invalid programs. The following are produced for the grammar defined above.

`{lam true false null}` `{if lam "Hello" "World"}` `{if 0 lam 1}` `{if + - lam}` `{}` `{if}` `{if ""}` `{if -1 "Hello"}` `{if 0 "Hello" eq? "World"}` `{if <= 1 -1 substring ""}` `{if "Hello" array 2.2 new-array "World" -22/7}` `{= aref}` `{"" =}` `{lam {true = e} f}` `{var {lam = ""} "World"}` `{var {false lam 1} 1}` `{var {null = var} j}` `{var {} ""}` `{var {+} -1}` `{var {- =} k}` `{var {eq? = g "World"} l}` `{var {<= = 2.2 h ""} "World"}` `{var {substring = -22/7 i "Hello" 0} -22/7}` `{var {array = m} if}` `{var}` `{var {new-array = ""}}` `{var {begin = "World"} o ""}` `{var {a = -1} 2.2 p "Hello"}` `{var {b = q} -22/7 r "World" 0}` `{= {true} s}` `{lam {lam} ""}` `{lam {aref} =}` `{lam}` `{lam {aset!}}` `{lam {b} 2.2 w}` `{lam {c} "Hello" -22/7 x}` `{lam {d} "World" 0 y ""}` `lam` `var`

Since the "valid" test case produced is so large, it would likely not be very enlightening to a student trying to understand where exactly their parser is failing. To help alleviate this, Sparse includes a utility for producing minimal failing test cases for a student's parser. For example, for one student's parser, the following minimal failing test cases were identified:

`{lam {true false null +} false}` `{lam {- * /} "Hello"}` `{lam {eq? <=} 1}` `{lam {array} 0}` `{var {false = "World"} x}` `{var {+ = 0} x}`

Here, the student's mistake was forbidding the built-ins as parameter names; the language's grammar and semantics allow redefining the names. It is worth noting that this student had actually passed all of the instructor's original test cases. Since the instructor's test cases only tried redefining a built-in once, a student whose submission was rejected the first time could simply special-case that one built-in and resubmit their assignment successfully. Manually writing test cases which redefine each built-in is rather tedious and requires a fair bit of foresight on the part of the instructor to know that that is an area where students might mistakes. By automating the generation of test cases, we can both reduce the tedium of writing test cases and make the test suite more comprehensive.

## Usage

Sparse exposes six functions: `generate-valid-testcase`, `generate-invalid-testcases`, `generate-valid-testcase-for-minimization`, `conforms-to-grammar?`, `produce-minimum-failing-testcases`, and `strip-minimization-info`.

The first three of these functions take an S-expression representing the grammar for which to generate test cases. Several examples are provided in `example-grammars.rkt` Consider the example grammar from before:

    (define phym4-grammar
      ;; The first list is for any legal identifiers you want Sparse to use explicitly.
      ;; This can be useful if you think students might forbid identifiers that are legal.
      '([true false null + - * / eq? <= substring array new-array aref aset! begin]
        ;; The second list is for the symbols that are not legal identifiers
        [lam = var if]
        ;; The third list is for the production rules of the grammar. The first element
        ;; should be a symbol for the grammar's nonterminal.
        ;; Unfortunately, Sparse does not support more than one nonterminal.
        [Expr
         ;; The production rules. Any numbers and symbols other than the name of
         ;; nonterminal are treated as literals.
         {if Expr Expr Expr}
         ;; '...' means that the term immediately to the left may appear zero or more times.
         {Expr Expr ...}
         ;; [id] (or (id) or {id}) refers to valid identifiers. This will use the
         ;; identifiers provided above, as well as the letters of the alphabet a-z.
         {var {[id] = Expr} ... Expr}
         {lam {[id] ...} Expr}
         [id]
         ;; This represents any string. At least one example string to use must be provided.
         [string "Hello" "World" ""]
         ;; This represents any number. At least one example number to use must be provided
         [number 0 1 -1 2.2 -22/7]]))

### `generate-valid-testcase`

`(generate-valid-testcase grammar)`. Using the grammar, produces one large S-expression which conforms to the grammar and is comprehensive in the following sense: each different production rule in the grammar will be used in place of each instance of a nonterminal in each production rule. For example, using the above grammar, the produced S-expression is guaranteed to have a subexpression like `{if _ {var {_ = _} _} _}`. A `var` expression is guaranteed to appear in each of the three subexpressions of an `if` expression. Likewise, each different 'type' of expression is guaranteed to appear in each spot where a subexpression is allowed. This process is deterministic; there's no point in generating multiple expressions from the same grammar.

### `generate-invalid-testcases`

`(generate-invalid-testcases grammar)`. Using the grammar, produces a list of simple S-expressions which do not conform to the grammar. The produced S-expressions are typically invalid because they use illegal identifiers or because they have incorrect lengths of lists. For instance, the above grammar will produce expressions that use `lam` in places where `lam` is not allowed, and will create `if` expressions that don't have exactly three subexpressions.

### `generate-valid-testcase-for-minimization`
`(generate-valid-testcase-for-minimization grammar)`. Produces an expression just like `generate-valid-testcase`, but that is additionally annotated with information that lets the test case minimization know which parts of the S-expression it is allowed to recurse into. Use `strip-minimization-info` to remove this information and get a pure S-expression.

### `conforms-to-grammar?`

`(conforms-to-grammar grammar expression)`. Checks whether the expression conforms the grammar specified. This will return `true` for the return value of `generate-valid-testcase` and `false` for all of the return values of `generate-invalid-testcases`.

### `produce-minimum-failing-testcases`

`(produce-minimum-failing-testcases testcase parse-function-to-test preprocess)`. Given a test case generated by `generate-valid-testcase-for-minimization` and a student's parse function, produces a list of "minimal" test cases on which the student's parser fails (i.e., throws an exception). The list of test cases is not exhaustive in the sense that there might be expressions on which the parser fails that won't be in the list until other expressions in the list have successfully parsed. The list of expressions will only be empty if the student's parser successfully parses the whole, large test case. If you find that the minimization takes longer than you would like, you might instruct your students to memoize their parse function. The `preprocess` argument is applied to any expression before it is passed to the student's parser. This is useful if, for instance, the language in question has a top-level construct around which expressions must be wrapped.

### `strip-minimization-info`

`(strip-minimization-info minimization-testcase)`. Strips the annotations from the return values of `generate-valid-testcase-for-minimization` to give a pure S-expression. `(strip-minimization-info (generate-valid-testcase-for-minimization grammar))` will produce the same value as `(generate-valid-testcase grammar)`.
