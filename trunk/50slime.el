;;;; my common-lisp program
(setq inferior-lisp-program "/usr/bin/sbcl")
;      lisp-indent-function 'common-lisp-indent-function)
(setq slime-lisp-implementations
      '((sbcl ("sbcl") :coding-system utf-8-unix)
	(clisp ("clisp") :coding-system utf-8-unix)))
        
(add-to-list 'load-path (expand-file-name "~/emacs/packages/slime") t)
(require 'slime)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
(slime-setup)

;; HyperSpec
(setq common-lisp-hyperspec-root 
      "file:///home/kid/ebook/computer/lisp/book/HyperSpec/")

(define-key lisp-mode-map
    (kbd "RET")
  'newline-and-indent)
;;;; 50slime.el ends here
