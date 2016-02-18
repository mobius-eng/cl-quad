;;;; package.lisp

(defpackage #:cl-quad
  (:use #:cl #:cl-numerics-utils)
  (:export #:*gauss-konrod-methods*
           #:integrate))

