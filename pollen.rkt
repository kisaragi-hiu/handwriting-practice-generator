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

;; practice blocks for reuse
(define (block-reference sample grid-or-line)
  (unless (list? sample) (set! sample (list sample)))
  `(div ([class ,(string-join `("reference" ,grid-or-line))]) ,@sample))

(define (block-write-over sample grid-or-line)
  (unless (list? sample) (set! sample (list sample)))
  `(div ([class ,(string-join `("write-over" ,grid-or-line))]) ,@sample))

(define (block-just-grid-or-line sample grid-or-line)
  (unless (list? sample) (set! sample (list sample)))
  `(div ([class ,(string-join `("empty" ,grid-or-line))]) ,@sample))

(define (block-empty sample)
  (unless (list? sample) (set! sample (list sample)))
  `(div ([class "empty"]) ,@sample))

(define (practice #:font [font #f]
                  #:vertical [vertical #f]
                  . blocks)
  (define writing-mode
    (match vertical
      (#t "vertical-lr")
      (x #:when (string? x) x)
      (_ "unset")))
  `(div ([class "word-practice"]
         [style ,(~a (format "writing-mode: ~a;" writing-mode)
                     (if font (format "font-family: ~a;" font) ""))])
    ,@blocks))

(define (word-practice #:grid? [grid? #f] #:font [font #f]
                       #:vertical [vertical #f]
                       . sample-text)
  (define grid-or-line
    (match `(,grid? ,vertical)
      ((list #t _) "with-grid")
      ((list _ #f) "with-line")
      (_ "with-line-vertical")))
  (practice
   #:font font #:vertical vertical
   (block-reference sample-text grid-or-line)
   (block-write-over sample-text grid-or-line)
   (block-just-grid-or-line sample-text grid-or-line)
   (block-empty sample-text)))

(define (paragraph-practice font . lines)
  `(@ ,@(map (lambda (item)
               (match item
                 ("break" '(div ((style "break-before: page"))))
                 (_ (word-practice #:font font item))))
             (remove* '("\n") lines))))

(define (article-practice font . article)
  (practice
   #:font font #:vertical #f
   (block-reference article "with-line")
   (block-write-over article "with-line")
   (block-write-over article "with-line")
   (block-empty article)))

(define (article-practice* font . lines)
  `(@ ,@(map (lambda (item)
               (match item
                 ("break" '(div ((style "break-before: page"))))
                 (_ (article-practice font item))))
             (remove* '("\n") lines))))
