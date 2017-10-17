#lang info

(define version "1.0")
(define deps '("base"))
(define build-deps
  '("racket-doc"
    "scribble-lib"))
(define scribblings '(("sparse.scrbl" () (parsing-library))))