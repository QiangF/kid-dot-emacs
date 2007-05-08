;;;; settings about c and c++ code editing
(add-hook 'c-mode-common-hook 'my-c-common-mode)

(require 'smart-compile)
(setq smart-compile-alist
      '(("/programming/guile/.*c$" .    "gcc -Wall %f `guile-config link` -o %n")
	("\\.c\\'"		.	"gcc -Wall %f -lm -o %n")
	("\\.[Cc]+[Pp]*\\'"	.	"g++ -Wall %f -lm -o %n")
	(emacs-lisp-mode	.	(emacs-lisp-byte-compile))
	(html-mode		.	(browse-url-of-buffer))
	(html-helper-mode	.	(browse-url-of-buffer))
	("\\.skb$"              .       "skribe %f -o %n.html")
	(haskell-mode           .       "ghc -o %n %f")
	(asy-mode               .       (call-interactively 'asy-compile-view))
	(muse-mode		.	(call-interactively 'muse-project-publish))))
(global-set-key (kbd "<f9>") 'smart-compile)

;; load gnu global
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/global")
	     t)
(autoload 'gtags-mode "gtags" "" t)

;; 加载 psvn
(require 'psvn)

(defun my-c-common-mode ()
  (gtags-mode 1)
  (define-key c-mode-base-map (kbd "<f8>") 'gtags-find-rtag)
  ;; 自动换行功能
  (c-toggle-auto-newline 1)
  ;; 此模式下，当按Backspace时会删除最多的空格
  (c-toggle-hungry-state)
  ;; 显示目前光标在哪个函数里面
  (which-function-mode t)
  (auto-fill-mode t)
  ;; 不使用 tab 作为缩进字符
  (setq indent-tabs-mode nil)
  (c-subword-mode 1)
  ;; hs-minor-mode 的设置
  (define-key c-mode-base-map
      (kbd "C-o h")
    'hs-hide-block)
  (define-key c-mode-base-map
      (kbd "C-o s")
    'hs-show-block)
  (define-key c-mode-base-map
      (kbd "C-o c")
    'hs-toggle-hiding)
  (define-key c-mode-base-map
      (kbd "C-o H")
    'hs-hide-all)
  (define-key c-mode-base-map
      (kbd "C-o S")
    'hs-show-all)
  (c-set-style "stroustrup")
  (c-set-offset 'inline-open 0)
  (kid-set-brace-styles)
  (kid-c-set-indent)
  (hs-minor-mode 1))

(defun kid-modify-alist (list entry)
  (let ((old-item (assoc (car entry) (symbol-value list))))
    (if old-item
	(setcdr old-item (cdr entry))
	(add-to-list list entry))))
(defun kid-set-brace-styles ()
  (mapc (lambda (entry)
	  (kid-modify-alist 'c-hanging-braces-alist entry))
	'((defun-close after)
	  (class-close)
	  (inline-close after)
	  (block-close  after)
	  (brace-list-close)
	  (extern-lang-close after)
	  (namespace-close after))))

(defun kid-c-set-indent ()
  (mapc (lambda (entry)
	  (kid-modify-alist 'c-offsets-alist entry))
	'((innamespace . [0]))))

;; 待整理，见 http://ann77.stu.cdut.edu.cn/EmacsAutoNewLineImpv.html
;; auto-newline 功能的改进
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
(defun my-c-mode-hook ()
  (interactive)
  (make-local-variable 'pre-command-hook)
  (add-hook 'pre-command-hook 'wcy-cancel-auto-new-line))

(defvar wcy-cancel-auto-new-line-command-list
  '(next-line previous-line)
  "a list of command which will trigger the cancel.")

(defun wcy-cancel-auto-new-line ()
  (interactive)
  (save-excursion
    (if (and (eq last-command 'c-electric-semi&comma)
             (memq this-command wcy-cancel-auto-new-line-command-list))
        (progn
          (if (and (boundp c-auto-newline) c-auto-newline)
              (progn
		(delete-blank-lines)))))))

;;;;;; 50c.el ends here
