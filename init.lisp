;; -*-lisp-*-
;; stumpwm config by Moritz Wilhelmy <mw barfooze de>, August 2016
;;
;; I don't like having a prefix key very much, it feels klunky to me, especially
;; if I press multiple keys after another, e.g. C-t n C-t n C-t n to cycle
;; through windows. Instead, I prefer having a dedicated modifier for window
;; management like in other tiling window managers, at least for more common
;; functions, so that I can keep pushing the super key and just hit the other
;; key repeatedly.
;;
;; For the less common functions I mostly didn't bother, so the prefix key is
;; located on s-t where it doesn't get in the way.
;;
;; Tested and considered usable with SBCL.

(in-package :stumpwm)

(set-prefix-key (kbd "s-t"))

;; Message window font

(set-font "-misc-fixed-medium-r-semicondensed-*-*-*-*-*-*-*-*-*")
;(set-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-15")
;(set-font "7x13")
;(set-font "fixed")

;; swank (See https://www.emacswiki.org/emacs/StumpWM ) - useful for hacking:
;; just attach emacs to stumpwm and hack while it's running.
(defcommand swank () ()
  "Turn on the swank server the first time.
Load a file that re-defines swank and then calls it."
  ;; Be careful with the quotes!
  (run-shell-command  "stumpish 'eval (load \"~/.stumpwm.d/swank.lisp\")'")
  (echo-string
   (current-screen)
   "Starting swank. M-x slime-connect RET RET, then (in-package stumpwm)."))
;;
(define-key *root-map* (kbd "C-s") "swank")

(defcommand firefox () () ; inspired by the "emacs" command
  "Start firefox unless it is already running, in which case focus it."
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand pidgin () () ; I swear, if I start using any more software
; regularly, I'll turn this into a general purpose function
  "Start pidgin unless it is already running, in which case focus it."
  (run-or-raise "pidgin" '(:class "Pidgin")))


;; Keymap - all of these start with "s-" so I made a nifty wrapper which
;; involves copy-pasting a bit less boilerplate code.
(mapcar
 (lambda (bind)
   (define-key *top-map* (kbd (concatenate 'string "s-" (car bind))) (cdr bind)))
 '(("Return"   . "exec urxvtcd")                   ;; Program keybindings
   ("S-Return" . "exec urxvtcd")
   ("p"      . "exec dmenu_run")
   ("e"      . "emacs")
   ("w"      . "firefox")
   ("m"      . "pidgin")

   ("bracketleft"  . "pull-hidden-previous")       ;; General window management
   ("bracketright" . "pull-hidden-next")
   ("i"      . "next-urgent")
   ("l"      . "redisplay")
   ("r"      . "iresize")
   ("s"      . "vsplit")
   ("S"      . "hsplit")
   ("x"      . "remove")
   ("f"      . "only")
   ("quoteright" . "vgroups")

   ("colon"     . "colon")                         ;; Command execution / debugging
   ("semicolon" . "eval")

   ("1"      . "select-window-by-number 0")        ;; Window selection keybindings
   ("2"      . "select-window-by-number 1")
   ("3"      . "select-window-by-number 2")
   ("4"      . "select-window-by-number 3")
   ("5"      . "select-window-by-number 4")
   ("6"      . "select-window-by-number 5")
   ("7"      . "select-window-by-number 6")
   ("8"      . "select-window-by-number 7")
   ("9"      . "select-window-by-number 8")
   ("0"      . "select-window-by-number 9")

   ("F1"     . "gselect 1")                        ;; Group keybindings
   ("F2"     . "gselect 2")
   ("F3"     . "gselect 3")
   ("F4"     . "gselect 4")
   ("F5"     . "gselect 5")
   ("F6"     . "gselect 6")
   ("F7"     . "gselect 7")
   ("F8"     . "gselect 8")
   ("F9"     . "gselect 9")
   ("F10"    . "gselect 10")

   ("S-F1"   . "gmove 1")                          ;; Group move keybindings
   ("S-F2"   . "gmove 2")
   ("S-F3"   . "gmove 3")
   ("S-F4"   . "gmove 4")
   ("S-F5"   . "gmove 5")
   ("S-F6"   . "gmove 6")
   ("S-F7"   . "gmove 7")
   ("S-F8"   . "gmove 8")
   ("S-F9"   . "gmove 9")
   ("S-F10"  . "gmove 10")
))

;(sync-keys) ; gotta make sure they're actually working

;; enable mode-line
(mode-line)

;;; Urgency Hooks
(defvar *urgent-popup-format* "^24^BUrgent: ~a")
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
