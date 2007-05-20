(autoload 'ruby-mode "ruby-mode"
  "Mode for edition ruby source files" t)
(add-to-list 'auto-mode-alist
	     '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist
	     '("ruby" . ruby-mode))

(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

(setq ri-ruby-script (expand-file-name
		      "~/emacs/extension/ri-emacs.rb"))
(autoload 'ri (expand-file-name
	       "~/emacs/extension/ri-ruby.el") nil t)

;; (add-to-list 'load-path
;; 	     "/home/kid/emacs/packages/emacs-rails")
;; (require 'rails)

;; (let ((pair (assoc "\\.rhtml$" auto-mode-alist)))
;;   (when pair
;;     (setcdr pair 'rhtml-mode)))
;; (add-to-list 'load-path
;; 	     "/home/kid/emacs/packages/rinari/rhtml")
;; (require 'rhtml-mode)
;; (add-hook 'rhtml-mode-hook
;; 	  '(lambda ()
;; 	     (auto-fill-mode -1)))

(add-hook 'html-mode-hook
	  '(lambda ()
	     (auto-fill-mode -1)
	     (setq tab-width 2)
	     (setq indent-tab-mode nil)))
(add-to-list 'auto-mode-alist
	     '("\\.rhtml$" . html-mode))

(require 'ruby-mode)
(require 'ruby-electric)
;; rails.el 把这三个字符的 syntax 语意改过了，虽然在 ruby 里面冒号
;; 问号以及下划线可以作为一个标识符的一部分，但是我还是希望 M-f 之
;; 类的操作能够真正的一个 "word" 那样来，不然会被搞晕了，而且很不
;; 方便
(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (let ((tbl ruby-mode-syntax-table))
	       (modify-syntax-entry ?! "." tbl)
	       (modify-syntax-entry ?: "." tbl)
	       (modify-syntax-entry ?_ "_" tbl)
	       (setq tab-width 2)
	       (ruby-electric-mode 1)
	       (setq indent-tab-mode nil))))

;;; haml mode support
(require 'haml-mode)