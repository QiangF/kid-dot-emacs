;;;; web 相关设置

;; 加载 Emacs-w3m 包
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/emacs-w3m/") 
	     t)
(require 'w3m-load)
(setq w3m-use-cookies t)

;; 浏览 HyperSpec 的时候使用 Emacs-W3m 
(setq browse-url-browser-function
      '(("ebook/computer/lisp/book/HyperSpec/" . w3m-browse-url)
	("." . browse-url-default-browser)))
