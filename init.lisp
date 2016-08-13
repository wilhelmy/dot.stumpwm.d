;; -*-lisp-*-

(in-package :stumpwm)

;(set-prefix-key (kbd "C-t"))
(set-prefix-key (kbd "quoteleft"))

;; Message window font
;(set-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-15")
;(set-font "7x13")
(set-font "fixed")

;; swank (See https://www.emacswiki.org/emacs/StumpWM )
(defcommand swank () ()
  "Turn on the swank server the first time.
Load a file that re-defines swank and then calls it."
  ;; Be careful with the quotes!
  (run-shell-command  "stumpish 'eval (load \"/path/to/swank.lisp\")'")
  (echo-string
   (current-screen)
   "Starting swank. M-x slime-connect RET RET, then (in-package stumpwm)."))
;;
(define-key *root-map* (kbd "C-s") "swank")
(define-key *root-map* (kbd "C-quoteleft") #'pull-hidden-other)
(define-key *root-map* (kbd "quoteleft") #'send-escape)

;; enable mode-line
(mode-line)

;;; Urgency Hooks
(defvar *urgent-popup-format* "^72^BUrgent: ~a")
(defun urgent-window-popup (window)
  "Pop up message stating the window title, in case a window sets the urgency hint"
  (message *urgent-popup-format* (escape-caret (window-name window))))
(add-hook *urgent-window-hook* #'urgent-window-popup)

;;; Define window placement policy...

;; Clear rules
(clear-window-placement-rules)

;; Last rule to match takes precedence!
;; TIP: if the argument to :title or :role begins with an ellipsis, a substring
;; match is performed.
;; TIP: if the :create flag is set then a missing group will be created and
;; restored from *data-dir*/create file.
;; TIP: if the :restore flag is set then group dump is restored even for an
;; existing group using *data-dir*/restore file.
;(define-frame-preference "Default"
;  ;; frame raise lock (lock AND raise == jumpto)
;  (0 t nil :class "Konqueror" :role "...konqueror-mainwindow")
;  (1 t nil :class "XTerm"))
;
;(define-frame-preference "Ardour"
;  (0 t   t   :instance "ardour_editor" :type :normal)
;  (0 t   t   :title "Ardour - Session Control")
;  (0 nil nil :class "XTerm")
;  (1 t   nil :type :normal)
;  (1 t   t   :instance "ardour_mixer")
;  (2 t   t   :instance "jvmetro")
;  (1 t   t   :instance "qjackctl")
;  (3 t   t   :instance "qjackctl" :role "qjackctlMainForm"))
;
;(define-frame-preference "Shareland"
;  (0 t   nil :class "XTerm")
;  (1 nil t   :class "aMule"))
;
;(define-frame-preference "Emacs"
;  (1 t t :restore "emacs-editing-dump" :title "...xdvi")
;  (0 t t :create "emacs-dump" :class "Emacs"))

(gnewbg "Pidgin")
(gnewbg "WWW")

(define-frame-preference "Pidgin"
  (2 t t :create "pidgin.dump" :class "Pidgin" :instance "Pidgin" :title nil :role nil)
  (0 t t :create "pidgin.dump" :class "Pidgin" :instance "Pidgin" :title nil :role "buddy_list")
  (1 t t :create "pidgin.dump" :class "Pidgin" :instance "Pidgin" :title nil :role "conversation"))

(define-frame-preference "WWW"
  (0 t t :create "www.dump" :class "Firefox"))
