#lang racket

(require threading
         racket/match
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

(provide (all-defined-out)
         (all-from-out racket/match))

(define to-html ->html)

(define (word-practice #:grid? [grid? #f] #:font [font #f]
                       #:vertical [vertical #f]
                       . sample-text)
  (define grid-or-line
    (match `(,grid? ,vertical)
      ((list #t _) "with-grid")
      ((list _ #f) "with-line")
      (_ "with-line-vertical")))
  (define writing-mode
    (match vertical
      (#t "vertical-lr")
      (x #:when (string? x) x)
      (_ "unset")))
  `(div ([class "word-practice"]
         [style ,(~a (format "writing-mode: ~a;" writing-mode)
                     (if font (format "font-family: ~a;" font) ""))])
    (div ([class ,(string-join `("reference" ,grid-or-line))]) ,@sample-text)
    (div ([class ,(string-join `("write-over" ,grid-or-line))]) ,@sample-text)
    (div ([class ,(string-join `("empty" ,grid-or-line))]) ,@sample-text)
    (div ([class "empty"]) ,@sample-text)))

(define (paragraph-practice font . lines)
  `(@ ,@(map (lambda (item)
               (match item
                 ("break" '(div ((style "break-before: page"))))
                 (_ (word-practice #:font font item))))
             (remove* '("\n") lines))))
