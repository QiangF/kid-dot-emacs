;;;; my msf-abbrev setting

;; ensure abbrev mode is always on
(setq-default abbrev-mode t)

;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;; load up modes I use
(require 'muse-mode)
(require 'cc-mode)

;; load up abbrevs for these modes
(require 'msf-abbrev)
(setq msf-abbrev-root "~/emacs/mode-abbrevs")
(msf-abbrev-load)

;; use C-c a to define a new abbrev for this mode
(global-set-key (kbd "C-c a") 'msf-abbrev-define-new-abbrev-this-mode)

;;;; 60msf-abbrev.el ends here
