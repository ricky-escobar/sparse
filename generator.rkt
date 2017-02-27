#lang racket

(struct rho (e) #:transparent)
(struct v (l) #:transparent)

(provide Recursive% List% Literal% Identifier% Variadic% generate-testcase)

(define (bool->int b)
  (match b
    [#t 1]
    [#f 0]
    [x x]))

(define (crit> crit1 crit2)
  (match* (crit1 crit2)
    [((cons f1 r1) (cons f2 r2))
     (if (= f1 f2)
         (crit> r1 r2)
         (> f1 f2))]
    [(_ _) #f]))

(define Recursive%
  (class object%
    (super-new)
    (define/public (recursivity) 1)
    (define rules #f)
    (define unused #f)

    (define/public (set-rules the-rules)
      (set! rules the-rules)
      (set! unused (apply mutable-set rules)))

    (define/public (get-usage last?)
      (define (criterion rule)
        (define the-criterion
          (list (and last? (>= (send rule recursivity) 2) (not (send rule is-used?)))
                (and last? (>= (send rule recursivity) 1) (not (send rule is-used?)))
                (set-member? unused rule)
                (not (send rule is-used?))
                (- (send rule recursivity))))
        (map bool->int the-criterion))
      (define the-rule (first (sort rules crit> #:key criterion)))
      (set-remove! unused the-rule)
      (rho (send the-rule get-usage last?)))

    (define/public (is-used?)
      (set-empty? unused))

   (define/public (to-string)
      "PYHM")))

(define List%
  (class object%
    (init subterms)
    (define subs subterms)
    (super-new)
    (define rec (apply + (map (λ (sub) (send sub recursivity)) subs)))
    (define/public (recursivity) rec)

    (define/public (set-rules the-rules)
      (for/list ([sub subs])
        (send sub set-rules the-rules)))

    (define/public (get-usage last?)
      (define usage-map (make-hash))
      (define rec-count 0)
      (define-values (do-first do-last)
        (partition (λ (i) (not (send (list-ref subs i) is-used?))) (range (length subs))))
      (define rec-order
        (append do-first do-last))
      (for/list ([i rec-order])
        (set! rec-count (+ rec-count (send (list-ref subs i) recursivity)))
        (hash-set! usage-map i (send (list-ref subs i) get-usage (and last? (= rec-count rec)))))
      (map (λ (i) (hash-ref usage-map i)) (range (length subs))))

    (define/public (is-used?)
      (andmap (λ (sub) (send sub is-used?)) subs))

    (define/public (to-string)
      (~a (map (λ (sub) (send sub to-string)) subs)))))

(define Literal%
  (class object%
    (init the-examples)
    (define examples the-examples)
    (super-new)
    (define/public (recursivity) 0)
    (define index 0)

    (define/public (set-rules the-rules) void)

    (define/public (get-usage last?)
      (define usage (list-ref examples index))
      (set! index (modulo (+ index 1) (length examples)))
      usage)

    (define/public (is-used?) #t)

    (define/public (to-string)
      (~a (list-ref examples index)))))

(define Variadic%
  (class object%
    (init repeated-term)
    (define rep repeated-term)
    (super-new)
    (define/public (recursivity) (send rep recursivity))
    (define repetitions 4)

    (define/public (set-rules the-rules)
      (send rep set-rules the-rules))

    (define/public (get-usage last?)
      (define reps (max repetitions (bool->int (or last? (not (send rep is-used?))))))
      (set! repetitions (max 0 (- repetitions 1)))
      (v (map (λ (i) (send rep get-usage (and (= i (- reps 1)) last?))) (range reps))))

    (define/public (is-used?) (send rep is-used?))

   (define/public (to-string)
      (string-append (send rep to-string) " ..."))))

(define Identifier%
  (class Literal%
    (init ids)
    (define default-ids '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
    (super-new [the-examples (append ids default-ids)])))

(define (set-rules rules)
  (for/list ([rule rules])
    (send rule set-rules rules))
  rules)

(define (children x)
  (match x
    [(v l) l]
    [else (list x)]))

(define (splice-v r)
  (match r
    [(rho e) (rho (splice-v e))]
    [(? list? l) (map splice-v (append-map children l))]
    [else r]))

(define (generate-testcase rules)
  (define populated (set-rules rules))
  (splice-v (rho (send (first rules) get-usage #t))))