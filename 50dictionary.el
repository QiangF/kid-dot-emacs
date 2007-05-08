;; 辞典相关

;; ;; 配置 dictionary 包
;; (add-to-list 'load-path
;; 	     (expand-file-name "~/emacs/packages/dictionary-1.8.7")
;; 	     t)
;; (autoload 'dictionary-search "dictionary" 
;;   "Ask for a word and search it in all dictionaries" t)
;; (autoload 'dictionary-match-words "dictionary"
;;   "Ask for a word and search all matching words in the dictionaries" t)
;; (autoload 'dictionary-lookup-definition "dictionary" 
;;   "Unconditionally lookup the word at point." t)
;; (autoload 'dictionary "dictionary"
;;   "Create a new dictionary buffer" t)
;; (autoload 'dictionary-mouse-popup-matching-words "dictionary"
;;   "Display entries matching the word at the cursor" t)
;; (autoload 'dictionary-popup-matching-words "dictionary"
;;   "Display entries matching the word at the point" t)
;; (autoload 'dictionary-tooltip-mode "dictionary"
;;   "Display tooltips for the current word" t)
;; (global-set-key (kbd "C-c s") 'dictionary-search)
;; (global-set-key (kbd "C-c m") 'dictionary-match-words)
;; (setq dictionary-server "localhost")
;; ;; (setq dictionary-tooltip-dictionary "wn")
;; ;; (require 'dictionary)
;; ;; (global-dictionary-tooltip-mode t)


;; ;; author: pluskid
;; ;; 调用 stardict 的命令行接口来查辞典
;; ;; 如果选中了 region 就查询 region 的内容，
;; ;; 否则就查询当前光标所在的词
;; ;(global-set-key [mouse-3] 'kid-star-dict)
;; ;(global-set-key (kbd "C-c d") 'kid-star-dict)
;; (defun kid-star-dict ()
;;   (interactive)
;;   (let ((begin (point-min))
;; 	(end (point-max)))
;;     (if mark-active
;; 	(setq begin (region-beginning)
;; 	      end (region-end))
;;       (save-excursion
;; 	(backward-word)
;; 	(mark-word)
;; 	(setq begin (region-beginning)
;; 	      end (region-end))))
;;     ;; 有时候 stardict 会很慢，所以在回显区显示一点东西
;;     ;; 以免觉得 Emacs 在干什么其他奇怪的事情。
;;     (message "searching for %s ..." (buffer-substring begin end))
;;     (tooltip-show 
;;      (shell-command-to-string 
;;       (concat "sdcv -n " 
;; 	      (buffer-substring begin end))))))

;;; 使用我自己写的扩展来查辞典
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)
