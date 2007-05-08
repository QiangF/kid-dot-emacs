;;;;;; settings about org-mode

(add-to-list 'auto-mode-alist
	     '("\\.org$" . org-mode)
	     t)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)

;; org-mark-ring 是一个循环结构， session 保持的时候会造成是循环，造成
;; 退出的时候一直循环，因此要把他 exclude 掉
(when (boundp 'session-globals-exclude)
  (add-to-list 'session-globals-exclude
	       'org-mark-ring))

;;;;;; 50org.el ends here
