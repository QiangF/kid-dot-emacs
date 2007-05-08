;;;; my customization for edition elisp
(define-key emacs-lisp-mode-map
    (kbd "RET")
    'newline-and-indent)


;;;; Function from ywb, get line and all the text properties into kill-ring
(defun ywb-get-line (arg)
  (interactive "P")
  (ywb-get-region (line-beginning-position) (line-end-position arg)))
;;;###autoload
(defun ywb-get-region (start end)
  (interactive "r")
  (let ((line  (format "%S" (buffer-substring start end))))
    (if (eq last-command 'kill-region)
        (kill-append line nil)
      (kill-new line))
    line))
