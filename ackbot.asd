;;;; ackbot.asd

(asdf:defsystem #:ackbot
  :serial t
  :description "Describe ackbot here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-irc
               #:cl-ppcre)
  :components ((:file "package")
               (:file "ackbot")
               (:file "config")
               (:file "command")
               (:file "utils")))
