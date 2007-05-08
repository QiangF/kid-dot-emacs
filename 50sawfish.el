;;; my sawfish editition configuration

(require 'sawfish)
(add-to-list 'auto-mode-alist
	     '("\\.jl$" . sawfish-mode))
(add-to-list 'auto-mode-alist
	     '("\\.sawfishrc" . sawfish-mode))

;; 50sawfish.el ends here
