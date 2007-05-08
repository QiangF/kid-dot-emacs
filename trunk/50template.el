;;;; configurations for template.el
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/template/lisp")
	     t)
(require 'template)

;; template.el 工作的方式大概是这样的，他通过加入 hook 到
;; `find-file-not-found-hooks' (事实上，这个变量已经在版本 22.1 里面不
;; 鼓励使用了，取而代之的是 `find-file-not-found-functions') ，在新建一
;; 个文件的时候他提供的 hook 将会被调用，这个时候他判断 `this-command'
;; ，看他是否在变量 `template-find-file-commands' 里面，如果在里面，那
;; 么就会执行 template 的相应工作了。而我跟踪发现 `ido-find-file' 执行
;; 之后 `this-command' 的值事实上是 `ido-exit-minibuffer' ，因此这儿必
;; 须这样设置才会生效。

(dolist (cmd '(ido-select-text ido-magic-forward-char ido-exit-minibuffer))
  (add-to-list 'template-find-file-commands
	       cmd))

;; 我所需要的 template 的功能只有 auto 而已，详细见
;; `template-initialize' 的文档。
(setq template-initialize '(auto))

;; 我扩充的标签
(add-to-list 'template-expansion-alist
	     '("USER_MAIL_ADDR" (insert (or user-mail-address
					 ""))))

(template-initialize)

;;;; 50template.el ends here
