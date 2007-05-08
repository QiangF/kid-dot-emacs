;; 使用 TRAMP
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/tramp/lisp"))
(require 'ange-ftp)
(require 'tramp)
(add-to-list 'tramp-default-method-alist 
	     '("10.13.122.225" "" "ssh"))
(add-to-list 'tramp-default-method-alist
	     '("kid" "" "sudo"))
(add-to-list 'tramp-default-user-alist
	     '("" "10.13.122.225" "root"))
(setq tramp-default-host "10.13.122.225")


;; 使用 TRAMP 把当前文件以 sudo 方式打开
(defun kid-find-alternative-file-with-sudo ()
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
	     buffer-file-name))))
(global-set-key (kbd "C-x C-r") 'kid-find-alternative-file-with-sudo)

;; coding-system ，通过指定 file-coding-system-alist 里面一个函数我
;; 可以看到传进去的参数大概是这个样子：
;; ((write-region "" nil "/tmp/ange-ftp8132kPY" nil silent
;; "/tmp/ange-ftp8132kPY"))
;; 终于知道为什么 "^/ftp:" 不能匹配了，应该写成 "^/tmp/ange-ftp" 。
(add-to-list 'auto-coding-alist
	     '("^/tmp/ange-ftp" . gb2312))
