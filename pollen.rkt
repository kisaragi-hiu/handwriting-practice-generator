#lang racket

(require threading
         txexpr
         pollen/core
         pollen/cache
         pollen/template
         pollen/decode
         pollen/pagetree
         pollen/render
         pollen/setup
         pollen/tag
         pollen/unstable/pygments)

(provide (all-defined-out))

(define to-html ->html)

(define (word-practice sample-text #:grid? [grid? #t])
  (define grid-or-line (if grid? "with-grid" "with-line"))
  `(div ([class "word-practice"])
        (div ([class ,(string-join `("reference" ,grid-or-line))]) ,sample-text)
        (div ([class ,(string-join `("write-over" ,grid-or-line))]) ,sample-text)
        (div ([class ,(string-join `("empty" ,grid-or-line))]) ,sample-text)
        (div ([class "empty"]) ,sample-text)))
