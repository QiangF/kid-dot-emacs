;; 各种文本操作以及文本艺术之类的东西

;; htmlize 功能
(require 'htmlize)
;(load "kid-htmlize")

;; 这样的效果
;; ,----[ foo bar ]
;; | This is the select
;; | region
;; `----
(defun kid-box-region (begin end title)
  (interactive "r\nsBox Title: ")
  (let ((old-buffer (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring old-buffer begin end)
      (goto-char (point-min))
      (insert ",----------[ " title " ]\n")
      (replace-regexp "^" "| ")
      (goto-char (point-max))
      ;; 检查最后是否有换行
      (if (search-backward-regexp "^| $" (point-min) t)
          (delete-char 2)
          (insert "\n"))
      (insert "`----------\n")
      (if (interactive-p)
          (let ((temp-buffer (current-buffer)))
            (switch-to-buffer (get-buffer-create "*kid-box-region-output*"))
            (erase-buffer)
            (insert-buffer temp-buffer))
          (buffer-string)))))


(add-hook 'text-mode-hook
          (lambda ()
            (auto-fill-mode 1)))

;; default major-mode 是 text-mode 而不是什么用都没有的 fundamental-mode
(setq default-major-mode 'text-mode)

;; major mode to edit moinmoin wiki
;(require 'moinmoin-mode)

;; major mode to edit FVWM config file
; ; Load fvwm−mode on Emacs startup
(require 'fvwm-mode)
                                        ; ; Automatically load fvwm−mode for fvwm configuration files
(setq auto-mode-alist
      (cons '("config" . fvwm-mode)
            (cons '("FvwmApplet−" . fvwm-mode)
                  (cons  '("FvwmScript−" . fvwm-mode)
                         auto-mode-alist))))
