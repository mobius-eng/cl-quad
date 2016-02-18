(in-package #:cl-quad)

(defvar *gauss-konrod-methods*
  '((:GK7-15  . 1)
    (:GK10-21 . 2)
    (:GK15-31 . 3)
    (:GK20-41 . 4)
    (:GK25-51 . 5)
    (:GK30-61 . 6)))

(defun integrate (function left right
                  &key (abs-tol 0d0) (rel-tol 1d-8) (method :GK7-15) (limit 200))
  (let ((left (coerce left 'double-float))
        (right (coerce right 'double-float)))
    (cond ((or (minus-infinite-p left) (plus-infinite-p right))
           (integrate-infinite function left right abs-tol rel-tol limit))
          (t (integrate-finate function left right abs-tol rel-tol method limit)))))


(defun integrate-finate (function left right abs-tol rel-tol method limit)
  (let* ((lenw (* 4 limit))
         (work (make-array lenw :element-type 'double-float))
         (iwork (make-array limit :element-type 'f2cl-lib:integer4))
         (method-key (or (cdr (assoc method *gauss-konrod-methods*)) 1)))
    (multiple-value-bind (junk a b epsabs epsrel key result abserr neval
                               ier z-lim z-lenw last)
        (quadpack:dqag function left right abs-tol rel-tol method-key
                       0d0 0d0 0 0 limit lenw 0 iwork work)
      (declare (ignore junk a b epsabs epsrel key z-lim z-lenw last))
      (values result abserr neval ier))))

(defun integrate-infinite (function left right abs-tol rel-tol limit)
  (let* ((lenw (* 4 limit))
         (work (make-array lenw :element-type 'double-float))
         (iwork (make-array limit :element-type 'f2cl-lib:integer4))
         (bound-inf (let ((left-inf (minus-infinite-p left))
                          (right-inf (plus-infinite-p right)))
                      (cond ((and left-inf right-inf) (list 0d0 2))
                            (left-inf (list right -1))
                            (t (list left 1))))))
    (multiple-value-bind (junk a b epsabs epsrel result abserr neval ier
                               z-lim z-lenw last)
        (quadpack:dqagi function (first bound-inf) (second bound-inf)
                        abs-tol rel-tol
                        0d0 0d0 0 0 limit lenw 0 iwork work)
      (declare (ignore junk a b epsabs epsrel z-lim z-lenw last))
      (values result abserr neval ier))))
