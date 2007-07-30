;; good small settings like cake

;; M-SPC 来设置 mark ，因为 C-SPC 被输入法占用了，C-@ 又
;; 难按
(global-set-key (kbd "M-<SPC>") 'set-mark-command)


;; ido 功能
(require 'ido)
(setq ido-enable-prefix nil)
(setq ido-enable-case nil)
;; 如果使用 multi-tty 的 Emacs 的话打开这个功能是很方便的，因为后台的
;; 一个不可见的 Emacs 占据了 *scratch* 这些 buffer
(setq ido-default-file-method 'samewindow)
(setq ido-default-buffer-method 'samewindow)
(ido-mode t)
;; ido-subdir 是红颜色，特别是在黑色背景下不好看
(custom-set-faces
 '(ido-subdir ((((class color) (background light)) (:foreground "Red"))
               (t (:foreground "Cyan")))))


;; 对配置文件进行加亮
(require 'generic)
(require 'generic-x)

;; Make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; enable ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; 在光标处而不是鼠标点击处粘贴
(setq mouse-yank-at-point t)

;; 复制和粘贴使用 X 剪切板
(setq x-select-enable-clipboard t)

;; 使用 C-x RET r 来重新加载文件，还可以指定
;; 加载用的编码

;; hippie-expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ; 搜索当前 buffer
        try-expand-dabbrev-visible         ; 搜索当前可见窗口
        try-expand-dabbrev-all-buffers     ; 搜索所有 buffer
        try-expand-dabbrev-from-kill       ; 从 kill-ring 中搜索
        try-complete-file-name-partially   ; 文件名部分匹配
        try-complete-file-name             ; 文件名匹配
        try-expand-all-abbrevs             ; 匹配所有缩写词
        try-expand-list                    ; 补全一个列表
        try-expand-line                    ; 补全当前行
        try-complete-lisp-symbol-partially ; 部分补全 elisp symbol
        try-complete-lisp-symbol))         ; 补全 lisp symbol

;; delete-region
(delete-selection-mode 1)

;; wind-move 功能，使用 shift+方向键在各个 window 之间移动
(require 'windmove)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; browse-kill-ring 功能
(require 'browse-kill-ring)
(require 'browse-kill-ring+)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;; 不知道为什么，按理说 M-s 应该是标准绑定，可是现在却没有了，我再重新绑定一下
(global-set-key (kbd "M-s") 'center-line)

(global-set-key (kbd "C-.") 'point-to-register)
(global-set-key (kbd "C-,") 'jump-to-register)

;;; press M-k in minibuffer to clear minibuffer -- borrow from icicles.el
(define-key minibuffer-local-map
    (kbd "M-k")
  'kill-whole-line)

;;; when there are two buffers with the same name, add their parent directory
;;; name to the buffer name to make them unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; getting things done
(defun gtd ()
  (interactive)
  (find-file (expand-file-name "~/.gtd/main.org")))

;; use cperl-mode instead of perl-mode
(defalias 'perl-mode 'cperl-mode)
(setq cperl-hairy t)
(setq cperl-auto-newline t)

;; list recent opened file in File menu
(require 'recentf)
(recentf-mode 1)
(setq recentf-exclude
      '("^/.*:.*"))
