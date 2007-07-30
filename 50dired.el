;;;; my dired customization

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utilities setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-hook 'dired-load-hook
;;        (lambda ()
;;          (load "dired-x")
;;          (load "dired-isearch")
;;          ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reuse dired buffer when jump to other directories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defadvice dired-find-file (around dired-find-file-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
        (filename (dired-get-file-for-visit)))
    ad-do-it
    (when (and (file-directory-p filename)
               (not (eq (current-buffer) orig)))
      (kill-buffer orig))))
(defadvice dired-up-directory (around dired-up-directory-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer)))
    ad-do-it
    (kill-buffer orig)))
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "/")
              (lambda (dir)
                (interactive "Dcd: ")
                (let ((orig (current-buffer)))
                  (dired dir)
                  (kill-buffer orig))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; convenient i-search in dired
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "C-s") 'dired-isearch-forward)
            (define-key dired-mode-map (kbd "C-r") 'dired-isearch-backward)
            (define-key dired-mode-map (kbd "M-C-s") 'dired-isearch-forward-regexp)
            (define-key dired-mode-map (kbd "M-C-r") 'dired-isearch-backward-regexp)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; omitting unintrested file(s)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'dired-mode-hook
          (lambda ()
            (setq dired-omit-files "^#\\|^\\..*") ; omit all hidden file which starts with `.'
            (dired-omit-mode 1)))                 ; initially omit unintrested files
(setq dired-omit-extensions
      '(".svn/" "CVS/" ".o" "~" ".bin" ".lbin" ".so" ".a" ".ln"
        ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".dvi"
        ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f"
        ".sparcf" ".fasl" ".ufsl" ".fsl" ".dxl" ".pfsl" ".dfsl"
        ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky"
        ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs"
        ".pyc" ".pyo" ".idx" ".lof" ".lot" ".glo" ".blg" ".bbl"
        ".cp" ".cps" ".fn" ".fns" ".ky" ".kys" ".pg" ".pgs" ".tp"
        ".tps" ".vr" ".vrs"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sorting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro kid-dired-define-sort (key switch)
  "define the key `s KEY' to sort use switch to ls."
  `(define-key dired-mode-map ,(concat "s" key)
     (lambda ()
       (interactive)
       (dired-sort-other (concat dired-listing-switches
                                 ,switch
                                 (if kid-dired-sort-reverse
                                     "r"
                                     "")
                                 (if kid-dired-sort-recursive
                                     "R"
                                     ""))))))
(defmacro kid-dired-define-toggle (key var)
  `(define-key dired-mode-map ,(concat "s" key)
     (lambda ()
       (interactive)
       (setq ,var (not ,var))
       (message "%s %s."
                (get ',var 'variable-documentation)
                (if ,var
                    "enabled"
                    "disabled")))))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; dired use `s' to switch sort by name/time, we undefine it so
            ;; that it can be used as prefix
            (define-key dired-mode-map
                (kbd "s")
              nil)
            (defvar kid-dired-sort-reverse nil
              "sort reversely")
            (defvar kid-dired-sort-recursive nil
              "sort recursively")
            (kid-dired-define-sort "X" "X")
            (kid-dired-define-sort "t" "t")
            (kid-dired-define-sort "S" "S")
            (kid-dired-define-sort "U" "U")
            (kid-dired-define-sort "u" "ut") ; sort by access time
            (kid-dired-define-sort "c" "ct") ; sort by ctime
            (kid-dired-define-sort "n" "")   ; sort by name :)
            (kid-dired-define-toggle "r" kid-dired-sort-reverse)
            (kid-dired-define-toggle "R" kid-dired-sort-recursive)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell command guess
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defadvice dired-run-shell-command (around kid-dired-run-shell-command (command))
  "run a shell command COMMAND .
If the COMMAND ends with `&' then run it in background and *discard* the
output, otherwise simply let the original `dired-run-shell-command' run it."
  (if (string-match "&[[:blank:]]*$" command)
        (let ((proc (start-process "kid-shell" nil shell-file-name
                                   shell-command-switch
                                   (substring command 0 (match-beginning 0)))))
          (set-process-sentinel proc 'shell-command-sentinel))
      ad-do-it))
(ad-activate 'dired-run-shell-command)

(defmacro kid-dired-define-assoc-group (patterns actions &optional name)
  "define an assoc entry to help dired guess the shell command.
PATTERN is a list of regexps used to match the filename.
NAME is a list of string or expression which eval to a string
to denote what shell command to execute. Optional NAME is
the name of this group , just for documentation purpose."
  (let ((item (gensym)))
    `(dolist (,item ',patterns)
       (setq dired-guess-shell-alist-user
             (cons (list ,item ,@actions) dired-guess-shell-alist-user)))))

(add-hook 'dired-load-hook
          (lambda ()
            (setq dired-guess-shell-alist-user nil)
            (kid-dired-define-assoc-group
             ("rm" "rmvb" "RM" "RMVB" "avi" "mpg" "mpeg" "mov")
             ("mplayer * &")
             video)
            (kid-dired-define-assoc-group
             ("pdf" "PDF")
             ("acroread * &" "xpdf * &")
             pdf-document)
            (kid-dired-define-assoc-group
             ("png" "jpg" "jpeg" "gif")
             ("xloadimage * &" "gqview * &")
             image)
            (kid-dired-define-assoc-group
             ("chm" "CHM")
             ("xchm * &")
             chm-document)
            (kid-dired-define-assoc-group
             ("html" "HTML" "htm" "HTML")
             ("firefox * &"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc utilities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 让 dired 可以递归地拷贝和删除目录
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
;; 让 dired 自动根据存在的另外一个 dired buffer 猜测复制等操作的目标路径
(setq dired-dwim-target t)
