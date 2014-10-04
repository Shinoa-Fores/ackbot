;;;; config.lisp

(in-package :ackbot)

;;;; Configuration file. This will be updated over time

(defvar *cmd-key* #\!)

(defvar *host* "")
(defvar *port* 6667)

(defvar *nick* "")

(defvar *channels* '(""))

;; System configuration
(defvar *load-path*    (merge-pathnames ".ackbot.d/" *default-pathname-defaults*))
(defvar *modules-path* (merge-pathnames "modules" *load-path*))
(defvar *load-modules* '())

(defun add-to-modules (module)
  (setf *load-modules* (cons module *load-modules*)))
