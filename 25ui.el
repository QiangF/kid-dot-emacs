;; UI relative settings

;; no startup screen
;; 关闭启动画面
(setq inhibit-startup-message t)

;; 关闭工具栏和菜单栏显示
(tool-bar-mode -1)
(menu-bar-mode 1)

;(set-scroll-bar-mode 'left)
;(modify-frame-parameters nil '((scroll-bar-width . 6)))

;; 显示行号功能
;; (require 'wb-line-number)
;; (setq wb-line-number-text-width 3)
;; (wb-line-number-enable)

;; 让标题栏显示buffer名
(setq frame-title-format "emacs@%b")

;; 高亮显示超出 fill-column 的部分。
(require 'highlight-beyond-fill-column)
(setq highlight-beyond-fill-column-in-modes
      '("emacs-lisp-mode"))

;; 光标靠近鼠标时让鼠标自动走开
(mouse-avoidance-mode 'jump)

;; 让括号配对的时候不跳到另外一边。
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0.5)

;; 如果是在图形界面下就加载不同的颜色主题库
(add-to-list 'load-path
	     "~/emacs/packages/color-theme-6.6.0")
(require 'color-theme)
(require 'color-theme-arjen)
(color-theme-arjen)
;;; (if window-system
;;;    (color-theme-calm-forest)
;;;  (color-theme-calm-forest))

;; 加载 tabbar
;; (require 'tabbar)
;; (tabbar-mode)
;; (global-set-key (kbd "<M-right>") 'tabbar-forward-tab)
;; (global-set-key (kbd "<M-left>") 'tabbar-backward-tab)
;; (global-set-key (kbd "<M-up>") 'tabbar-backward-group)
;; (global-set-key (kbd "<M-down>") 'tabbar-forward-group)
;; (defun kid-tabbar-buffer-groups-function (buffer)
;;   "Return the list of group names BUFFER belongs to.
;; Return only one group for each buffer."
;;   (with-current-buffer (get-buffer buffer)
;;     (cond
;;      ((or (get-buffer-process (current-buffer))
;;           (memq major-mode
;;                 '(comint-mode compilation-mode)))
;;       '("Process"))
;;      ((or (member (buffer-name)
;;                '("*scratch*" "*Messages*"))
;;        (memq major-mode
;;              '(help-mode apropos-mode Info-mode Man-mode
;;                completion-list-mode)))
;;       '("Common"))
;;      ((eq major-mode 'dired-mode)
;;       '("Dired"))
;;      ((memq major-mode
;;             '(rmail-mode
;;               rmail-edit-mode vm-summary-mode vm-mode mail-mode
;;               mh-letter-mode mh-show-mode mh-folder-mode
;;               gnus-summary-mode message-mode gnus-group-mode
;;               gnus-article-mode score-mode gnus-browse-killed-mode))
;;       '("Mail"))
;;      ((memq major-mode
;;          '(c-mode c++-mode ruby-mode python-mode emacs-lisp-mode))
;;       '("Develop"))
;;      ((memq major-mode
;;          '(muse-mode LaTeX-mode org-mode text-mode))
;;       '("Document"))
;;      (t
;;       (list
;;        "default"  ;; no-grouping
;;        (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
;;            mode-name
;;          (symbol-name major-mode)))))))
;; (setq tabbar-buffer-groups-function 'kid-tabbar-buffer-groups-function)


;; 加载显示行号的功能
(require 'setnu)
(require 'setnu+)

;; (setq window-system-default-frame-alist
;;       '(
;;      ;; if frame created on x display
;;      (x
;;       (tool-bar-lines . 0))))

;; 光标的设置
(blink-cursor-mode -1)                  ;不要让光标闪烁
;(setq cursor-in-echo-area nil)         ;在 echo area 显示光标

;;; (create-fontset-from-fontset-spec
;;;   "-*-terminus-medium-r-normal--12-*-*-*-c-*-fontset-terminus")
;;; (set-default-font "fontset-terminus")
;;; (setq default-frame-alist
;;;       (append '((font . "fontset-terminus"))
;;;               default-frame-alist))
;;; (set-fontset-font
;;;  "fontset-terminus" 'han
;;; ; "-*-simsun-medium-r-*-*-12-*-*-*-p-*-gb2312.1980-*"
;;;  "-wenquanyi-wenquanyi bitmap song-medium-r-normal-12-120-75-75-p-119-gbk-0"
;;;  nil 'prepend)


;; (if (string-match "23" (emacs-version))
;;     (progn
;;       (set-fontset-font
;;        "fontset-default" 'chinese-gbk
;;        "-misc-simsun-medium-r-normal--0-0-0-0-p-0-gbk-0"
;;        nil 'prepend)
;;       (set-fontset-font
;;        "fontset-default" 'big5
;;        "-arphic-uming-medium-r-normal--14-140-100-100-m-140-big5-0"
;;        nil 'perpend)))
