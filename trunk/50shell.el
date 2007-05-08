;; shell 和 eshell 相关设置

;; 让 shell mode 可以正常显示颜色
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(require 'ansi-color)
;; eshell 的颜色
;; 这样可以显示颜色，但是当在文件很多的目录里面显示的时候
;; 会很慢
;(add-hook 'eshell-preoutput-filter-functions
;	  'ansi-color-apply)
;; 这样直接把颜色滤掉
(add-hook 'eshell-preoutput-filter-functions
	  'ansi-color-filter-apply)

;; eshell 的提示符
(setq eshell-prompt-function
      (lambda ()
	(concat (file-name-nondirectory (eshell/pwd))
		(if (= (user-uid) 0) " # " " $ "))))

;; 如果文件是 shell 脚本，则在保存后自动添加可执行权限
(add-hook 'after-save-hook
        #'(lambda ()
        (and (save-excursion
               (save-restriction
                 (widen)
                 (goto-char (point-min))
                 (save-match-data
                   (looking-at "^#!"))))
             (not (file-executable-p buffer-file-name))
             (shell-command (concat "chmod u+x " (shell-quote-argument buffer-file-name)))
             (message
              (concat "Saved as script: " buffer-file-name)))))

;; 快速切换到 shell 并 cd 到当前 buffer 所在的目录
(autoload 'shell-toggle "shell-toggle" 
 "Toggles between the *shell* buffer and whatever buffer you are editing."
 t)
(autoload 'shell-toggle-cd "shell-toggle" 
 "Pops up a shell-buffer and insert a \"cd <file-dir>\" command." t)
(global-set-key (kbd "<C-f9>") 'shell-toggle-cd)
