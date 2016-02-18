;;;; cl-quad.asd

(asdf:defsystem #:cl-quad
  :description "Describe cl-quad here"
  :author "Alexey Cherkaev"
  :license "LGPLv3"
  :depends-on (#:cl-numerics-utils #:quadpack)
  :serial t
  :components ((:file "package")
               (:file "cl-quad")))

