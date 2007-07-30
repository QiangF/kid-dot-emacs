;; 我的el库
(add-to-list 'load-path
             (expand-file-name "~/emacs/extension/")
             t)

;; preload some packages, so that dumpped emacs load faster
(require 'byte-opt)
(require 'cl)
(load "cl-macs")
(load "cl-seq")
(load "cl-extra")
(require 'edmacro)
(require 'delsel)
(require 'easy-mmode)
(require 'regexp-opt)
(require 'dired-x)
(require 'dired-isearch)
(require 'advice)
(require 'avoid)

;; 使用 emacs server
;(server-start)

;; 加载 session
;; (require 'session)
;; (add-hook 'after-init-hook
;;        'session-initialize)
;(desktop-save-mode 1)
;(setq desktop-restore-eager 5)
