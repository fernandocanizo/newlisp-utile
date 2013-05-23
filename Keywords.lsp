#!/usr/bin/env newlisp
;; Creation Date: Tue, 21 May 2013 23:01:38 -0300
;; @author Fernando Canizo (aka conan) - http://conan.muriandre.com/
;; @module Keywords
;; @description Keywords (almost) a-la Common Lisp
;; @version 2013.05.22
;;
;; This module provides a keyword facility for symbols.
;; Use default functor to create keywords like the ones in Common Lisp, which are
;; symbols evaluating to themselves (unless a value is given) living in the
;; Keywords context.
;; Use dash functor to create keywords living on the context from where the
;; function is called.


;; @notes
;; Couldn't make default functor self modifying, had to use _choose-method instead
;; When the chooser was the default functor, newlisp core dumped

(context 'Keywords)


;; @syntax
;; @param
;; @return
;; @example

(define (_choose-method (_method 0))
	(if (= 0 _method) ; store keywords in this context by default
		(setq Keywords:Keywords (append (lambda) (list (first _in-keywords)) (rest _in-keywords)))
		; else
		(setq Keywords:Keywords (append (lambda) (list (first _in-calling-context)) (rest _in-calling-context)))))


;; @syntax
;; @param
;; @return
;; @example

(define (_in-keywords _symbol (_value nil))
	(constant (sym (term _symbol))
		(if (true? _value)
			(eval _value)
			; else
			(sym (term _symbol))))
	; in any case delete symbol created inside MAIN
	(unless (true? (eval _symbol))
		(delete _symbol)))


;; @syntax
;; @param
;; @return
;; @example

(define (_in-calling-context _symbol (_value nil))
	(context (prefix _symbol))
	(constant (sym _symbol)
		(if (true? _value)
			(eval _value)
			; else
			(sym _symbol))))


(context MAIN)
; set a shortcut
(constant '. Keywords)
