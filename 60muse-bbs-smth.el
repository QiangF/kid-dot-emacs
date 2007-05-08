;;;; implement a publish style of muse to bbs syntax
;;;; copied from pluskid@NewSMTH, with little change specifying for SMTH BBS

(defvar kid-bbs-smth-markup-strings
  '((image-link . "\nimage: %s\n")
    (url . "%s")
    (link . " %s ")
    (emdash . "--")
    (rule . "--------------------")
    (fn-sep . "--------------------\n")
    (enddots . "....")
    (dots . "...")
    (section . "\033\033[1;33;46m")
    (section-end . "\033\033[m")
    (subsection . "\033\033[1;33;45m ")
    (subsection-end . "\033\033[m")
    (subsubsection . "\033\033[1;33;44m  ")
    (subsubsection-end . "\033\033[m")
    (section-other . "\033\033[1;33;40m   ")
    (section-other-end . "\033\033[m")
;;;; 从这里往下begin部分最后的\n是为了防止上色导致不能自动缩进，这样会带来排版多
;;出一个回车，但我暂时不知道有什么更好的办法：）
    (begin-literal . "\033\033[1;32m")
    (end-literal . "\033\033[0m")
    (begin-underline . "\033\033[4m")
    (end-underline . "\033\033[0m")
    (begin-emph . "\033\033[33m")
    (end-emph . "\033\033[0m")
    (begin-more-emph . "\033\033[41m")
    (end-more-emph . "\033\033[0m")
    (begin-most-emph . "\033\033[45m")
    (end-most-emph . "\033\033[0m"))
  "strings used to publish bbs style of muse document")

(defvar kid-bbs-smth-markup-functions
  '((quote . kid-bbs-smth-markup-quote)
    (footnote . kid-bbs-smth-markup-footnote)
    (list . kid-bbs-smth-markup-list)))

(defvar kid-bbs-smth-markup-tags
  '(("example" t nil nil kid-bbs-smth-markup-example)
    ("src" t t nil kid-bbs-smth-markup-src)      ; 这儿要使用 htmlize 来输出是不可能的了
    ("pre" t nil nil kid-bbs-smth-markup-pre)))

(defun kid-bbs-smth-markup-quote ()
  (replace-regexp "^"
                  "\033\033[1;36m"
                  nil
                  (match-beginning 0)
                  (match-end 0)))

(defun kid-bbs-smth-markup-footnote ()
  (cond
    ;; beginning of line, footnote text
    ((= (muse-line-beginning-position) (match-beginning 0))
     (muse-insert-markup "\033\033[33m[" (match-string 1) "]")
     (save-excursion
       (save-match-data
         (let* ((beg (goto-char (match-end 0)))
                (end (and (search-forward "\n\n" nil t)
                          (prog1
                              (copy-marker (match-beginning 0))
                            (goto-char beg)))))
           (while (re-search-forward "^" end t)
             (replace-match "\033\033[33m"))))))
    ;; or else reference of footnote
    (t (muse-insert-markup "\033\033[33m[" (match-string 1) "]\033\033[0m")))
  (replace-match ""))

(defun kid-bbs-smth-markup-example (beg end)
  (while (re-search-forward "^" end t)
    (replace-match "\033\033[1;32m"))
  (end-of-line)
  (muse-publish-mark-read-only beg (point)))

(defun kid-bbs-smth-markup-src (beg end attrs)
  (while (re-search-forward "^" end t)
    (replace-match "\033\033[1;32m"))
  (end-of-line)
  (muse-publish-mark-read-only beg (point)))

(defun kid-bbs-smth-markup-pre (beg end)
  (while (re-search-forward "^" end t)
    (replace-match "\033\033[33m"))
  (end-of-line)
  (muse-publish-mark-read-only beg (point)))

;; 这儿写得这么麻烦的原因是，如果某个 list item 是多行的，在 Emacs 编
;; 辑的时候后面的行会有缩进，保持这个缩进很漂亮，但是有缩进会被认为是
;; quote 而进行解析，所以要把这儿的行首的空白给 mark-read-only 了。
;; 同时，定义列表是没有缩进的，所以不用管这个问题。
(defun kid-bbs-smth-markup-list ()
  (let* ((str (match-string 1))
         (type (muse-list-item-type str))
         (indent (buffer-substring (muse-line-beginning-position)
                                   (match-beginning 1)))
         (last (match-beginning 0)))
    (cond
      ((eq type 'ul)
       (unless (eq (char-after (match-end 1)) ?-)
         (delete-region (match-beginning 0) (match-end 0))
         (muse-insert-markup "- "))
        (save-excursion
          (save-match-data
            (muse-forward-list-item 'ul indent)
            (let ((item-end (point)))
              (goto-char last)
              (while (re-search-forward "^[[:blank:]]+" item-end t)
                (muse-publish-mark-read-only (match-beginning 0)
                                             (match-end 0)))))))
      ((eq type 'ol)
       (unless (eq (char-after (match-end 1)) ?-)
         (delete-region (match-beginning 0) (match-end 0))
         (muse-insert-markup (concat "\033\033[1;32m" str "\033\033[0m"))
        (save-excursion
          (save-match-data
            (muse-forward-list-item 'ol indent)
            (let ((item-end (point)))
              (goto-char last)
              (while (re-search-forward "^[[:blank:]]+" item-end t)
                (muse-publish-mark-read-only (match-beginning 0)
                                             (match-end 0))))))))
      ((not (string= (match-string 2) ""))
       ;; must have an initial term
       (goto-char (match-beginning 0))
       (muse-insert-markup "\033\033[1;32m")
       (save-excursion
         (save-match-data
           (if (search-forward "::" nil t)
               (replace-match "\033\033[0m"))))))))


(unless (assoc "kid-bbs-smth" muse-publishing-styles)
  (muse-define-style "kid-bbs-smth"
                     :suffix    nil
                     :regexps   nil
                     :functions 'kid-bbs-smth-markup-functions
                     :strings   'kid-bbs-smth-markup-strings
                     :tags      'kid-bbs-smth-markup-tags
                     :specials  nil
                     :before    nil
                     :after     nil
                     :header    "Title:\n\n\033\033[1;33m[<lisp>
                                (muse-publishing-directive \"title\")
                                </lisp>]\033\033[m  <lisp>
(muse-publishing-directive \"date\")</lisp>\n\n\nText:\n\n\n"
                     :footer    nil
                     :browser   'kid-mediawiki-browse-file))

;;;; muse-SMTHBBS-style.el ends here
