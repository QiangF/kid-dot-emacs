;;;; my configuration for programming scheme in Emacs
;;;; see http://www.cs.huji.ac.il/support/emacs/pllab.html
(custom-set-variables
 '(quack-default-program "mzscheme -M errortrace")
 '(quack-fontify-style 'emacs)
 '(quack-global-menu-p nil)
 '(quack-run-scheme-always-prompts-p nil)
 '(quack-run-scheme-prompt-defaults-to-last-p t)
 '(quack-tabs-are-evil-p t)
 )

(require 'quack)

(require 'keep-end nil t)
(add-hook 'inferior-scheme-mode-hook
	  (lambda ()
	    (keep-end-watch-this (current-buffer))
	    (define-key inferior-scheme-mode-map (kbd "RET") 'kid-run-scheme-mode-send-or-indent)))


(defun kid-run-scheme-mode-sexp-complete-p ()
  (save-excursion
    (while (not (or (eq 'output (get-text-property (1- (point)) 'field))
		    (equal (point) (point-min))))
      (goto-char (previous-single-property-change (point) 'field)))
    (ignore-errors
      (forward-sexp)
      t)))
(defun kid-run-scheme-mode-send-or-indent ()
  (interactive)
  (if (kid-run-scheme-mode-sexp-complete-p)
      (comint-send-input)
      (newline-and-indent)))

;;; skribe settings
(eval-after-load "skribe"
  '(define-key skribe-mode-map
    (kbd "C-c C-v")
    (lambda ()
      (interactive)
      (browse-url (concat "file:"
			  (expand-file-name
			   (file-name-sans-extension
			    (buffer-file-name)))
			  ".html")))))
