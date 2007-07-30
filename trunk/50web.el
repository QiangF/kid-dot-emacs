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

;; 编辑 HTML 的时候要用到 screen-lines.el
(autoload 'screen-lines-mode "screen-lines"
  "Toggle Screen Lines minor mode for the current buffer." t)
(autoload 'turn-on-screen-lines-mode "screen-lines"
  "Turn on Screen Lines minor mode for the current buffer." t)
(autoload 'turn-off-screen-lines-mode "screen-lines"
  "Turn off Screen Lines minor mode for the current buffer." t)

;; php-mode
(autoload 'php-mode "php-mode" "PHP mode" t)
(setq auto-mode-alist
      (append
       '(("\\.php$" . php-mode)
         ("\\.php5$" . php-mode))
       auto-mode-alist))
