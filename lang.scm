(module lang (lib "eopl.ss" "eopl")                

  ;; grammar for the LETREC language

  (require "drscheme-init.scm")
  
  (provide (all-defined-out))

  ;;;;;;;;;;;;;;;; grammatical specification ;;;;;;;;;;;;;;;;
  
  (define the-lexical-spec
    '((whitespace (whitespace) skip)
      (comment ("%" (arbno (not #\newline))) skip)
      (identifier
       (letter (arbno (or letter digit "_" "-" "?")))
       symbol)
      (number (digit (arbno digit)) number)
      (number ("-" digit (arbno digit)) number)
      ))
  
  (define the-grammar
    '((program (expression) a-program)

      (expression (number) const-exp)
      (expression
        ("minus" expression expression)
        minus-rand)
      
      (expression
       ("plus" expression expression)
       plus-rand)
      
      (expression
       ("times" expression expression)
       times-rand)
      
      (expression
       ("divided" "by" expression expression)
       divide-rand)
      
      (expression
       ("zero?" "(" expression ")")
       zero?-exp)

      (expression
       ("if" expression "then" expression "else" expression)
       if-logic)

      (expression (identifier) var-exp)

      (expression
       ("let" identifier "equal" expression)
       a-decl)   

      (expression
       ("proc" "(" identifier ")" expression)
       proc-exp)

      (expression
       ("(" expression expression ")")
       call-exp)

      (expression
        ("letrec"
          identifier "(" identifier ")" "=" expression
           "in" expression)
        letrec-exp)
      
      ))
  
  ;;;;;;;;;;;;;;;; sllgen boilerplate ;;;;;;;;;;;;;;;;
  
  (sllgen:make-define-datatypes the-lexical-spec the-grammar)
  
  (define show-the-datatypes
    (lambda () (sllgen:list-define-datatypes the-lexical-spec the-grammar)))
  
  (define scan&parse
    (sllgen:make-string-parser the-lexical-spec the-grammar))
  
  (define just-scan
    (sllgen:make-string-scanner the-lexical-spec the-grammar))
  
  )
