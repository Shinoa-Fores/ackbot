;;;; ackbot.asd

(asdf:defsystem #:ackbot
  :serial t
  :description "IRC Bot"
  :author "Chris Font <font.christopher [at] gmail [dot] com>"
  :license ""
  :depends-on (#:cl-irc
               #:cl-ppcre)
  :components ((:file "package")
               (:file "ackbot")
               (:file "config")
               (:file "command")
               (:file "utils")))
