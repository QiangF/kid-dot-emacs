;; AUCTeX的相关设
(add-to-list 'load-path (expand-file-name "~/emacs/packages/auctex") t)
(add-to-list 'load-path (expand-file-name "~/emacs/packages/auctex/preview/") t)
(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)

;; cdlatex-mode ，可以便捷地输入
(setq cdlatex-env-alist
      '(("cjk" "\\begin{CJK*}{UTF8}{song}\n?\n\\end{CJK*}" nil)))
(setq cdlatex-command-alist
      '(("cjk" "Insert CJK env" "" cdlatex-environment ("cjk") t nil)))
(require 'cdlatex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
;(setq-default TeX-master nil)

(autoload 'CJK-insert-space "cjkspace"
  "Insert tildes appropriately in CJK document." t)
(defvar kid-toggle-cjk-space-is-tilde nil
  "Where to input tilde or just space.")
(make-variable-buffer-local 'kid-toggle-cjk-space-is-tilde)
(defun kid-toggle-cjk-space ()
  (interactive)
  (if kid-toggle-cjk-space-is-tilde
      (progn
	(setq kid-toggle-cjk-space-is-tilde nil)
	(define-key LaTeX-mode-map " " 'self-insert-command))
    (setq kid-toggle-cjk-space-is-tilde t)
    (define-key LaTeX-mode-map " " 'CJK-insert-space)))


(add-hook 'LaTeX-mode-hook
	  '(lambda ()
	    (setq TeX-style-path (cons (expand-file-name "~/emacs/tex-style/")
				  TeX-style-path))
	    (turn-on-auto-fill)
	    (turn-on-reftex)
	    (flyspell-mode 1)
	    (menu-bar-mode 1)
	    (turn-on-cdlatex)
	    ;; use <tab> to indent, C-i for cdlatex
	    (define-key LaTeX-mode-map
	     (kbd "<tab>")
	     'indent-for-tab-command)
	    ))

;;; Asymptote editing support
(autoload 'asy-mode "asy-mode.el" "Asymptote major mode." t)
(autoload 'lasy-mode "asy-mode.el" "hybrid Asymptote/Latex major mode." t)
(autoload 'asy-insinuate-latex "asy-mode.el" "Asymptote insinuate LaTeX." t)
(add-to-list 'auto-mode-alist '("\\.asy$" . asy-mode) t)

;;;;;; 50auctex.el ends here
