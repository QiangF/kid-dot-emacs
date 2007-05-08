;;;; settings for editing python file

;;; python-mode.el setting
;; (add-to-list 'load-path
;; 	     (expand-file-name "~/emacs/packages/python-mode/")
;; 	     t)
;; (autoload 'python-mode "python-mode" "Python Mode." t)
(add-hook 'python-mode-hook
	  '(lambda ()
	     (c-subword-mode)))
