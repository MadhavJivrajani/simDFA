#lang racket/base

(require racket/contract
         racket/list)

; these ensure valid input types
(provide (contract-out
          [struct dfa
            ((alphabet (listof symbol?))
             (states (listof symbol?))
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
  (define states-in-transitions
    (for/list ([state (in-list transitions)])
      (first state)))
  (cond
    [(not (equal? states states-in-transitions))
     (raise-user-error 'make-dfa
                       "transitions for states must be defined once per state:\n ~a"
                       transitions)]
    [(ormap (λ (t) (check-duplicates (rest t) #:key first)) transitions)
     (raise-user-error 'make-dfa
                       "more than one transition defined for some input in:\n ~a"
                       transitions)]
    [(ormap (compose (λ (n) (< n (length alphabet))) sub1 length) transitions)
     (raise-user-error 'make-dfa
                       "not enough transitions defined for some input in:\n ~a"
                       transitions)]
    [else 
     (dfa alphabet states transitions initial final)]))

(define (string->symbol-list str)
  (map (compose string->symbol string) (string->list str)))

(define (evaluate a-dfa input)
  (let eval-util ([state (dfa-initial a-dfa)]
                  [input (string->symbol-list input)])
    (cond
      [(null? input) (if (member state (dfa-final a-dfa)) #t #f)]
      [(not
        (member (first input) (dfa-alphabet a-dfa))) #f]
      [else
       (define transition
         (assoc state (dfa-transitions a-dfa)))
       (define next-state
         (cadr (assoc (first input) (rest transition))))
       (eval-util next-state (rest input))])))
    
