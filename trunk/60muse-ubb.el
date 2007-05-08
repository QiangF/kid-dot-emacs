;;;; implement a publish style of muse to ubb code
(defvar kid-muse-ubb-markup-strings
  '((url . "[url=%s][color=blue][u]%s[/u][/color][/url]")
    (link . " %s ")
    (emdash . "--")
    (rule . "----------------------")
    (fn-sep . "[color=#000080]==================== Footnote ====================[/color]\n")
    (enddots . "....")
    (dots . "...")
    (section . "[color=#000080]=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n  ")
    (section-end . "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[/color]")
    (subsection . "[color=green]=======================================================\n    ")
    (subsection-end . "\n=======================================================[/color]")
    (subsubsection . "[color=orange]      ")
    (subsubsection-end . "\n---------------------------------------------[/color]")
    (section-other . "        ")
    (section-other-end . "\n-------------------------")
    (begin-literal . "[b][color=blue]")
    (end-literal . "[/color][/b]")
    (begin-underline . "[u]")
    (end-underline . "[/u]")
    (begin-emph . "[i]")
    (end-emph . "[/i]")
    (begin-more-emph . "[b]")
    (end-more-emph . "[/b]")
    (begin-most-emph . "[b][i]")
    (end-most-emph . "[/i][/b]")))

(defvar kid-muse-ubb-markup-tags
  '(("example" t nil nil kid-muse-ubb-markup-example)
    ("src" t t nil kid-muse-ubb-markup-src)))

(defvar kid-muse-ubb-markup-specials
    '((?\: . "&#58;")			; I escape `:' so that cc98 won't auto convert URL like `http://...' in code
      (?\[ . "&#91;")))
(require 'muse-xml)
(defun kid-muse-ubb-decide-specials (contex)
  "Determine the specials to escape, depending on CONTEX."
  (cond ((memq contex '(email url image))
	 'muse-xml-escape-url)
        ((eq context 'url-extra)
         muse-xml-markup-specials-url-extra)
	(t kid-muse-ubb-markup-specials)))
(defvar kid-muse-ubb-markup-functions
  '((footnote . kid-muse-ubb-markup-footnote)
    (list . kid-muse-ubb-markup-list)))

;; (defun kid-muse-ubb-markup-example (beg end &optional attrs)
;;    (muse-publish-escape-specials beg end nil 'example)
;;    (let* ((title (or (cdr (assoc "type" attrs)) "CODE"))
;;    (boxed (kid-box-region (1+ beg) end (concat "[b]" title "[/b]"))))
;;      (delete-region beg end)
;;      (insert "[color=#639342]")
;;      (insert boxed)
;;      (insert "[/color]")
;;      (muse-publish-mark-read-only beg (point))))
(defun kid-muse-ubb-markup-src (beg end attrs)
  (if (getf (cdr (muse-style muse-publishing-current-style)) :cc98)
      (let* ((mode (or (cdr (assoc "type" attrs)) "nil"))
	     (mode-func (or (cdr (assoc mode kid-muse-srctag-modes-alist))
			    (cdr (find-if (lambda (pair)
					    (save-match-data
					      (string-match (car pair) mode)))
					  auto-mode-alist))
			    'fundamental-mode))
	     (text (delete-and-extract-region beg end)))
	(require 'ubbit)
	(save-restriction
	  (narrow-to-region (point) (point))
	  (muse-insert-markup
	   (with-temp-buffer
	     (insert text)
	     (funcall mode-func)
	     (font-lock-fontify-buffer)
	     (ubbit-ubb-region (point-min) (point-max))))))
      (kid-muse-ubb-markup-example beg end)))
	  
(defun kid-muse-ubb-markup-example (beg end)
  (muse-publish-escape-specials beg end nil 'example)
  (if (getf (cdr (muse-style muse-publishing-current-style)) :cc98)
      (let ((title "CODE"))
	(goto-char beg)
	(insert "[color=#639342]------------------------------[ [b]" 
		title 
		"[/b] ]------------------------------")
	(goto-char end)
	(insert (make-string (+ 64 (length title)) ?\-)
		"[/color]\n"))
      (progn
	(goto-char beg)
	(insert "[code]")
	(goto-char end)
	(insert "[/code]")))
  (muse-publish-mark-read-only beg (point)))

(defun kid-muse-ubb-markup-footnote ()
  (cond
    ((= (muse-line-beginning-position) (match-beginning 0))
          (muse-insert-markup "[" (match-string 1) "]")
     (save-excursion
       (save-match-data
	 (let* ((beg (goto-char (match-end 0)))
		(end (and (search-forward "\n\n" nil t)
			  (prog1
			      (copy-marker (match-beginning 0))
			    (goto-char beg)))))
	   (while (re-search-forward "^ " end t)
	     (replace-match "&nbsp;"))))))
    ;; or else reference of footnote
    (t (muse-insert-markup "[" (match-string 1) "]")))
  (replace-match ""))

(defun kid-muse-ubb-markup-list ()
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
	 (muse-insert-markup (concat "[color=red][b]" str "[/b][/color]"))
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
       (muse-insert-markup "[u][color=#6595D6]")
       (save-excursion
	 (save-match-data
	   (if (search-forward "::" nil t)
	       (progn
		 (replace-match "")
		 (muse-insert-markup "[/color][/u]")))))))))

(unless (assoc "kid-ubb" muse-publishing-styles)
  (muse-define-style "kid-ubb"
		     :strings 'kid-muse-ubb-markup-strings
		     :tags 'kid-muse-ubb-markup-tags
		     :specials 'kid-muse-ubb-decide-specials
		     :functions 'kid-muse-ubb-markup-functions))
(unless (assoc "kid-cc98" muse-publishing-styles)
  (muse-derive-style "kid-cc98" "kid-ubb"
		     :cc98 t))
