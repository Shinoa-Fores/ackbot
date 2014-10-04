;;;; utils.lisp

;;;; ACKBOT Utilities

(in-package :ackbot)

(defun readable-time (seconds)
  "Utility function to convert seconds to hh:mm:ss"
  (let ((hours (truncate seconds 3600))
        (minutes (truncate seconds 60))
        (seconds (mod seconds 60)))
    (format nil "~A:~A:~A" hours minutes seconds)))
