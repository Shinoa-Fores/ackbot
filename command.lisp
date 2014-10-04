;;;; command.lisp

(in-package #:ackbot)

;;; Command Look-Up Table
(defvar *cmds*
  (make-hash-table :test 'equal))

(defvar *cmd-keys* '())

(defun add-to-cmds (key func level)
  "Adds command and function to command table and updates command list."
  (when (not (gethash key *cmds*))
    (setf (gethash key *cmds*) (cons func level))
    (setf *cmd-keys*
          (sort
           (cons key *cmd-keys*)
           #'string<))))

;; Add commands here
(add-to-cmds "help"   'send-help   0)
(add-to-cmds "uptime" 'send-uptime 0)

(defun get-cmd (key)
  "Returns function that is attached to the input command. Returns nil if none."
  (gethash key *cmds*))

(defun unknown-cmd (msg)
  "Inform the user that you have no clue what they meant."
  (cl-irc:privmsg (irc:connection msg)
                  (irc:source msg)
                  (format nil "~A: Unknown command. For help, use ~Ahelp"
                          (irc:user msg)
                          *cmd-key*)))

;; At the moment, this is short-circuited eventually it will check to see if the
;; user has authorization for the command
(defun get-user-level (user)
  200)

;; Parse input message to get desired command, then execute it
(defun handle-cmd (msg)
  "This function will split the message into its command component"
  (let ((cmd (car (cl-ppcre:split "\\s+" (cadr (irc:arguments msg))))))
    (if (cl-ppcre:scan (format nil "^~A" *cmd-key*) cmd)
        (find-cmd msg (remove *cmd-key* cmd))
        (unknown-cmd msg))))

(defun find-cmd (msg cmd)
  "Look up command and execute."
  (let ((call-func (get-cmd cmd)))
    (if call-func
        (let ((fn    (car call-func))
              (level (cdr call-func)))
          (if (<= level (get-user-level msg))
              (funcall fn msg)
              (unknown-cmd msg)))
        (unknown-cmd msg))))

(defun send-help (msg)
  "Send user help privately."
  (irc:privmsg
   (irc:connection msg)
   (irc:source msg)
   (format nil "Available commands are:"))
  (loop for cmd in *cmd-keys*
       do (irc:privmsg
           (irc:connection msg)
           (irc:source msg)
           (format nil "~A~A" *cmd-key* cmd))))

(defun send-uptime (msg)
  "Send user current uptime, privately"
  (let ((time-up (- (get-universal-time) *start-time*)))
    (irc:privmsg
     (irc:connection msg)
     (irc:source msg)
     (format nil "Uptime: ~A"
             (readable-time time-up)))))
