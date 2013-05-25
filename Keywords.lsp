#!/usr/bin/env newlisp
;; Creation Date: Tue, 21 May 2013 23:01:38 -0300
;; @author Fernando Canizo (aka conan) - http://conan.muriandre.com/
;; @module Keywords
;; @description Keywords (almost) a-la Common Lisp
;; @version 2013.05.24
;;
;; This module provides a keyword facility for symbols.
;;
;; Use default functor to create keywords, which are symbols evaluating to
;; themselves (unless a value is given) living in the Keywords context or in
;; the calling context.
;;
;; You'll got to make a first call to define were would you like to save your
;; keywords.


(context 'Keywords)

(constant 'SAVE_IN_KEYWORDS_CONTEXT 0)
(constant 'SAVE_IN_CALLING_CONTEXT 1)

;; @syntax (Keywords <saving-method>)
;; @param <saving-method> Can be 0 or 1
;; @syntax (Keywords <symbol> [value])
;; @param <symbol> A symbol to become keyword
;; @param [value] Any value. If not provided keyword evaluates to itself
;; @return Nothing
;; @example
;; (load "Keywords.lsp")
;; ; first time set your desired saving mode
;; (. .:SAVE_IN_KEYWORDS_CONTEXT)
;;
;; (define (sandwich)
;;  (doargs (_arg)
;;   (if (= _arg .:with-ketchup)
;;    (println "bread-ketchup-cheese-bread")
;;    (println "bread-cheese-bread"))))
;;
;; (. 'with-ketchup) ; register keyword
;; (sandwich .:with-ketchup) ; use it


(define (Keywords:Keywords (_method 0))
	(begin ; so functor it's composed of just two lists
		(if (= SAVE_IN_KEYWORDS_CONTEXT _method)
			(begin
				(push (first _in-keywords) Keywords:Keywords -1)
				(push (cons 'begin (rest _in-keywords)) Keywords:Keywords -1))
			; else
			(begin
				(push (first _in-calling-context) Keywords:Keywords -1)
				(push (cons 'begin (rest _in-calling-context)) Keywords:Keywords -1)))
		(pop Keywords:Keywords) ; parameters
		(pop Keywords:Keywords) ; body
))


;; This function is meant for internal use only
(define (_in-keywords _symbol (_value nil))
	(constant (sym (term _symbol))
		(if (true? _value)
			(eval _value)
			; else
			(sym (term _symbol))))
	; in any case delete symbol created inside MAIN
	(unless (true? (eval _symbol))
		(delete _symbol)))


;; This function is meant for internal use only
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
