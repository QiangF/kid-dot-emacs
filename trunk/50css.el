;;;;;; 编辑 css 文件所用的东西

(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist
	     '("\\.css\\'" . css-mode)
	     t)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function 'cssm-c-style-indenter)
;;;;;; 50css.el ends here
