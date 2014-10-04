;;;; ackbot.lisp

(in-package #:ackbot)

;;; "ackbot" goes here. Hacks and glory await!

(defvar *verbose* nil)
(defvar *logging* nil)

;; Connection variable
(defvar *connection* nil)

;; Time that the bot is initialized
(defvar *start-time* 0)

(defun log-msg (msg)
  (format t "~A: ~A says ~A~%"
          (irc:received-time msg)
          (irc:user msg)
          (irc:arguments msg)))

;; This needs to be renamed to private/public handler
(defun handle-msg (msg)
  "Default message handler"
  (when *logging*
    (log-msg msg))
  (handle-cmd msg))

(defun init ()
  "This will load up our configuration files located at both config and ~/.ackbot.d/init.el"
  (ensure-directories-exist *load-path*)
  (load (merge-pathnames "init.el" *load-path*))
  (loop for module in *load-modules*
       do #'(lambda (mod)
            (when *verbose*
              (format t "Loading module ~A~%" mod))
            (load (merge-pathnames mod *modules-path*)))))

;; TODO: Update this to not rely on the deprecated
;;  (start-background-message-handler)
(defun start-bot (&optional (verbose t) (logging t))
  "Starts a bot connection to *host* on port *port* using nick *nick*."
  (setf *verbose* verbose)
  (setf *logging* logging)
  (when *verbose*
    (format t "Starting bot...~%"))
  (init)
  (setf *start-time* (get-universal-time)) ;; Grab current time
  (setf *connection* (irc:connect :nickname *nick*
                                  :server   *host*))
  ;; TODO: Load User Database
  (mapcar #'(lambda (channel)
              (cl-irc:join *connection* channel)) ;; Join all configured channels
          *channels*)
  (cl-irc:add-hook *connection* 'irc:irc-privmsg-message 'handle-msg)
  ;; TODO: Add Public message handler
  (cl-irc:start-background-message-handler *connection*))
