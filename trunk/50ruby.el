(require 'ruby-electric)
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
(setq ri-ruby-script (expand-file-name
                      "~/emacs/extension/ri-emacs.rb"))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

(autoload 'ri "ri-ruby" nil t)

(defun kid/self-insert-and-indent ()
  "self-insert and indent line.
Bind this command to \"e\", so that you will be automatically
indented when typing \"else\"."
  (interactive)
  (self-insert-command 1)
  (indent-according-to-mode))
(defun kid/self-insert-or-replace ()
  "self-insert or replace.
Useful for \")\", \"]\" and similar stuffs."
  (interactive)
  (if (eq (char-after (point))
          last-input-char)
      (forward-char 1)
    (self-insert-command 1)))
(defun kid/ruby-self-insert-or-pair ()
  (interactive)
  (if (eq (char-after (point))
          last-input-char)
      (forward-char 1)
    (ruby-electric-matching-char 1)))
(defun kid/ruby-smart-newline ()
  "Newline and some other stuffs"
  (interactive)
  (if (ruby-electric-space-can-be-expanded-p)
      (progn
	(newline-and-indent)
	(save-excursion
	  (newline 1)
	  (ruby-insert-end)))
    (newline-and-indent)
    (when (looking-at "}")
      (move-end-of-line 0)
      (newline-and-indent)
      (indent-according-to-mode))))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)
             (ruby-electric-mode 1)
             (local-set-key (kbd "<f1>") 'ri)
             (local-set-key (kbd "M-TAB") 'ri-ruby-complete-symbol)
             (local-set-key (kbd "RET") 'kid/ruby-smart-newline)
             (dolist (ch '("e" "f"))
               (local-set-key ch 'kid/self-insert-and-indent))
             (dolist (ch '("]" ")" "}"))
               (local-set-key ch 'kid/self-insert-or-replace))
             (dolist (ch '("\"" "'" "|"))
               (local-set-key ch 'kid/ruby-self-insert-or-pair))
             (setq indent-tabs-mode nil)))


;; Support for rspec
(add-to-list 'compilation-mode-font-lock-keywords
	     '("^\\([[:digit:]]+\\) examples?, \\([[:digit:]]+\\) failures?\\(?:, \\([[:digit:]]+\\) pendings?\\)?$"
	       (0 '(face nil message nil help-echo nil mouse-face nil) t)
	       (1 compilation-info-face)
	       (2 (if (string= "0" (match-string 2))
		      compilation-info-face
		    compilation-error-face))
	       (3 compilation-info-face t t)))

;;; (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
;;; (autoload 'javascript-mode "javascript" nil t)

;;; (add-to-list 'load-path
;;;              "~/emacs/packages/emacs-rails")
;;; (require 'rails)

;;; (load "~/emacs/packages/nxml/autostart.el")
;;; (add-to-list 'auto-mode-alist
;;;              '("\\.rhtml$" . kid-rhtml-mode))
;;; ;; no special background
;;; (setq mumamo-chunk-coloring 'no-chunks-colored)
;;; (setq nxhtml-skip-welcome t)

;;; ;; do not turn on rng-validate-mode automatically, I don't like
;;; ;; the anoying red underlines
;;; (setq rng-nxml-auto-validate-flag nil)

;;; ;; force to load another css-mode, the css-mode in nxml package
;;; ;; seems failed to load under my Emacs 23
;;; (let ((load-path (cons "~/emacs/extension/"
;;;                        load-path)))
;;;   (require 'css-mode))

;;; (defun kid-rhtml-mode ()
;;;   (nxhtml-mode)
;;;   ;; I don't use cua-mode, but nxhtml always complains. So, OK, let's
;;;   ;; define this dummy variable
;;;   (make-local-variable 'cua-inhibit-cua-keys)
;;;   (setq mumamo-current-chunk-family '("eRuby nXhtml Family" nxhtml-mode
;;;                                       (mumamo-chunk-eruby
;;;                                        mumamo-chunk-inlined-style
;;;                                        mumamo-chunk-inlined-script
;;;                                        mumamo-chunk-style=
;;;                                        mumamo-chunk-onjs=)))
;;;   (mumamo-mode)
;;;   (rails-minor-mode t)
;;;   (auto-fill-mode -1)
;;;   (setq tab-width 2)
;;;   (setq indent-tab-mode nil))


;;; (require 'ruby-mode)
;;; (require 'ruby-electric)
;;; ;; rails.el 把这三个字符的 syntax 语意改过了，虽然在 ruby 里面冒号
;;; ;; 问号以及下划线可以作为一个标识符的一部分，但是我还是希望 M-f 之
;;; ;; 类的操作能够真正的一个 "word" 那样来，不然会被搞晕了，而且很不
;;; ;; 方便
;;; (add-hook 'ruby-mode-hook
;;;           '(lambda ()
;;;              (let ((tbl ruby-mode-syntax-table))
;;;                (modify-syntax-entry ?! "." tbl)
;;;                (modify-syntax-entry ?: "." tbl)
;;;                (modify-syntax-entry ?_ "_" tbl)
;;;                (setq tab-width 2)
;;;                (ruby-electric-mode 1)
;;;                (setq indent-tab-mode nil))))

;;; ;;; haml mode support
;;; (require 'haml-mode)
