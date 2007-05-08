;;;; outline (minor) mode 的一些设置

;; 让 outline-minor-mode 的前缀绑定到 C-o 上，反正 C-o 不常用
(setq outline-minor-mode-prefix (kbd "C-o"))

;; 更方便的按键
(mapc (lambda (bind)
	(define-key outline-minor-mode-map
	    (car bind)
	  (cdr bind)))
      `((,(kbd "C-o q") . hide-sublevels)
	(,(kbd "C-o a") . show-all)
	(,(kbd "C-o t") . hide-body)
	(,(kbd "C-o c") . hide-entry)
	(,(kbd "C-o e") . show-entry)
	(,(kbd "C-o l") . hide-leaves)
	(,(kbd "C-o k") . show-branches)
	(,(kbd "C-o d") . hide-subtree)))

;;;;;; 50outline.el ens here