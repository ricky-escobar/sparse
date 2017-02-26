#lang racket

(require "test-runner.rkt")
(define phym2-testcase `(ρ {* (ρ {h (ρ {g (ρ {+ (ρ {- (ρ {/ (ρ {f (ρ {/ (ρ {* (ρ {ifleq0 (ρ {d (ρ {ifleq0 (ρ {+ (ρ a) (ρ {a (ρ b)})}) (ρ {b (ρ 1)}) (ρ {c (ρ 0)})})}) (ρ {+ (ρ -1) (ρ {- (ρ 0) (ρ {/ (ρ {/ (ρ {ifleq0 (ρ {/ (ρ c) (ρ {* (ρ t) (ρ {ifleq0 (ρ {ifleq0 (ρ d) (ρ {/ (ρ 2.2) (ρ {/ (ρ 0) (ρ {ifleq0 (ρ -22/7) (ρ {ifleq0 (ρ 0) (ρ e) (ρ {* (ρ {- (ρ {+ (ρ {/ (ρ {/ (ρ {/ (ρ {/ (ρ {ifleq0 (ρ o) (ρ 2.2) (ρ {ifleq0 (ρ {ifleq0 (ρ {ifleq0 (ρ {ifleq0 (ρ k) (ρ l) (ρ {/ (ρ i) (ρ j)})}) (ρ m) (ρ 0)}) (ρ n) (ρ -22/7)}) (ρ 0) (ρ h)})}) (ρ {e})}) (ρ 0)}) (ρ -1)}) (ρ g)}) (ρ 0)}) (ρ 1)}) (ρ f)})}) (ρ p)})})}) (ρ q)}) (ρ r) (ρ s)})})}) (ρ u) (ρ v)}) (ρ w)}) (ρ x)})})}) (ρ y)}) (ρ z)}) (ρ a)}) (ρ b)}) (ρ c)}) (ρ d)}) (ρ e)}) (ρ f) (ρ g)}) (ρ h) (ρ i) (ρ j)}) (ρ k)}))
(define phym3-testcase `(ρ {if (ρ {lam {} (ρ {lam {} (ρ {(ρ {lam {} (ρ {var {m = (ρ {lam {} (ρ {+ (ρ {lam {} (ρ {/ (ρ {lam {} (ρ {if (ρ {(ρ {(ρ {var {j = (ρ {(ρ {<= (ρ {(ρ {/ (ρ {(ρ {if (ρ {var {h = (ρ {var {g = (ρ {eq? (ρ {var {f = (ρ {/ (ρ {var {e = (ρ {if (ρ {* (ρ {- (ρ {/ (ρ {+ (ρ {if (ρ {/ (ρ {/ (ρ {if (ρ {if (ρ a) (ρ {lam {a b c d} (ρ b)}) (ρ {lam {e f g} (ρ 1)})}) (ρ {(ρ c) (ρ {lam {h i} (ρ 0)}) (ρ {(ρ -1) (ρ {var {a = (ρ d)} (ρ {lam {j} (ρ true)})}) (ρ {<= (ρ e) (ρ {(ρ 0) (ρ {/ (ρ f) (ρ {(ρ false) (ρ {if (ρ 2.2) (ρ {var {b = (ρ -22/7)} (ρ {(ρ {(ρ {(ρ {(ρ {var {c = (ρ 0)} (ρ {var {d = (ρ false)} (ρ {eq? (ρ -1) (ρ {var (ρ {/ (ρ 2.2) (ρ {var (ρ {if (ρ 0) (ρ {* (ρ 0) (ρ {- (ρ true) (ρ {/ (ρ 0) (ρ {+ (ρ y) (ρ {if (ρ false) (ρ {/ (ρ true) (ρ {/ (ρ {- (ρ {* (ρ {eq? (ρ {<= (ρ w) (ρ {lam {} (ρ {/ (ρ {/ (ρ {/ (ρ {/ (ρ {/ (ρ v) (ρ {lam {} (ρ {if (ρ u) (ρ 2.2) (ρ {if (ρ {if (ρ {if (ρ {if (ρ {if (ρ q) (ρ r) (ρ {(ρ {if (ρ o) (ρ p) (ρ {/ (ρ m) (ρ n)})})})}) (ρ s) (ρ false)}) (ρ t) (ρ 0)}) (ρ true) (ρ -22/7)}) (ρ 0) (ρ l)})})})}) (ρ false)}) (ρ 0)}) (ρ -1)}) (ρ k)})})}) (ρ true)}) (ρ 0)}) (ρ 1)}) (ρ {if (ρ {var (ρ false)}) (ρ {if (ρ {var (ρ -22/7)}) (ρ h) (ρ {var (ρ i)})}) (ρ {+ (ρ {var (ρ 0)}) (ρ j)})})})}) (ρ x)})})})})}) (ρ z)})})})})})})}) (ρ true)}) (ρ 0)}) (ρ 1)}) (ρ g)})}) (ρ a)})})}) (ρ b)})}) (ρ c)}) (ρ d) (ρ e)}) (ρ f)}) (ρ g)}) (ρ h)}) (ρ i) (ρ j)}) (ρ k)}) (ρ l)}) (ρ m)}) (ρ n)}) (ρ o) (ρ p)})} (ρ q)}) (ρ r)})} (ρ s)}) (ρ t)})} (ρ u)})} {i = (ρ v)} (ρ w)}) (ρ x) (ρ y)})}) (ρ z)})}) (ρ a)})})} {k = (ρ b)} {l = (ρ c)} (ρ d)})})}) (ρ e) (ρ f)})}) (ρ g)})}) (ρ h)})})} {n = (ρ i)} {o = (ρ j)} {p = (ρ k)} (ρ l)})})})})}) (ρ m) (ρ n)}))
(define phym4-testcase `(ρ {if (ρ {lam {} (ρ {lam {} (ρ {(ρ {lam {} (ρ {var {new-array = (ρ {lam {} (ρ {if (ρ {(ρ {(ρ {var {eq? = (ρ {(ρ {if (ρ {var {* = (ρ {var {- = (ρ {if (ρ {if (ρ true) (ρ {lam {true false null +} (ρ false)}) (ρ {lam {- * /} (ρ "Hello")})}) (ρ {(ρ null) (ρ {lam {eq? <=} (ρ 1)}) (ρ {(ρ "World") (ρ {var {true = (ρ +)} (ρ {lam {array} (ρ 0)})}) (ρ {if (ρ "Hello") (ρ {var {false = (ρ "World")} (ρ {(ρ -1) (ρ -) (ρ "Hello")})}) (ρ {(ρ 0) (ρ 2.2)})}) (ρ 0)}) (ρ {var {null = (ρ -22/7)} (ρ {var {+ = (ρ 0)} (ρ {if (ρ 1) (ρ {if (ρ 0) (ρ *) (ρ {var (ρ /)})}) (ρ {if (ρ {var (ρ "Hello")}) (ρ "World") (ρ eq?)})})})}) (ρ {var (ρ -1)})}) (ρ "World")})} (ρ 0)})} {/ = (ρ {if (ρ {if (ρ <=) (ρ 0) (ρ 0)}) (ρ 2.2) (ρ -22/7)})} (ρ array)}) (ρ new-array) (ρ aref)})})} {<= = (ρ aset!)} {array = (ρ begin)} (ρ substring)})})}) (ρ a) (ρ b)})})} {aref = (ρ c)} {aset! = (ρ d)} {begin = (ρ e)} (ρ f)})})})})}) (ρ g) (ρ h)}))

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program4"
 'parse
 phym4-testcase
 (λ (s) s))

#;(run-tests
 "C:\\Users\\Ricky\\Downloads\\Program3"
 'parse
 phym3-testcase
 (λ (s) s))

(run-tests
  "C:\\Users\\Ricky\\Downloads\\Program2"
 'parse
 phym2-testcase
 (λ (s) s))