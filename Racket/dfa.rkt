#lang racket/base

(require racket/contract)

; these ensure valid input
(provide (contract-out
          [struct dfa
            ((alphabet (listof symbol?))
             (states (listof symbol?))
             ; (transitions (listof any/c))
             (transitions (cons/c symbol? (listof (list/c symbol? symbol?))))
             (initial symbol?)
             (final (listof symbol?)))]
          [evaluate (dfa? string? . -> . boolean?)])
         make-dfa)

; the data structure for dfa
(struct dfa (alphabet states transitions initial final))

(define (make-dfa #:alphabet    alphabet
                  #:states      states
                  #:transitions transitions
                  #:initial     initial
                  #:final       final)
  (dfa alphabet states transitions initial final))

(define (string->symbol-list str)
  (map (compose string->symbol string) (string->list str)))

(define (evaluate a-dfa input)
  (let eval-util ([state (dfa-initial a-dfa)]
                  [input (string->symbol-list input)])
    (cond
      [(null? input) (if (member state (dfa-final a-dfa)) #t #f)]
      [(not
        (member (car input) (dfa-alphabet a-dfa))) #f]
      [else
       (define transition
         (assoc state (dfa-transitions a-dfa)))
       (define next-state
         (cadr (assoc (car input) (cdr transition))))
       (eval-util next-state (cdr input))])))
    
