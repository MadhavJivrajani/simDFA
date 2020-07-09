#lang racket/base

(require "dfa.rkt")

; at most 3 a's
(define example-dfa
  (make-dfa #:alphabet    '(a b)
            #:states      '(q0 q1 q2 q3 q4)
            #:transitions '([q0 (a q1) (b q0)]   ; q0 on a -> q1 AND q0 on b -> q2
                            [q1 (a q2) (b q1)]
                            [q2 (a q3) (b q2)]
                            [q3 (a q4) (b q3)]
                            [q4 (a q4) (b q4)])
            #:initial     'q0
            #:final       '(q0 q1 q2 q3)))

(for ([input (in-list '("aaab" "aaaab" "" "bbbb" "foo"))])
  (displayln (format "~a : ~a"
                   (if (equal? "" input) "Ɛ" input)
                   (evaluate example-dfa input))))
; aaab : #t
; aaaab : #f
; Ɛ : #t
; bbbb : #t
; foo : #f
