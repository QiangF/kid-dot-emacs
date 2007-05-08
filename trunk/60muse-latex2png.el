;;;; my extension and customization to muse-latex2png.el
(require 'muse-latex2png)

;; muse-latex2png.el add `latex' tag to muse-publish-markup-tags, I
;; only use this tag in html format, so I add this to
;; muse-html-markup-tags and made my own customization.
;; I define a new function `kid-muse-latex' in case I want to do some
;; customization before pass it to `muse-publish-latex-tag' .
;;
;; here's my customization:
;; * support for a scale attributes for latex tag
(add-to-list 'muse-html-markup-tags
	     '("latex" t t nil kid-muse-html-latex))
;; I also want to use regexp to markup inline latex equations of the
;; form `$\alpha$' because I'm too lazy to write
;; <latex inline="t">$\alpha$</latex>
(add-to-list 'muse-html-markup-regexps
	     '(1600 "\\$[^$]*\\$" 0 kid-muse-html-latex-inline))
(defvar kid-muse-html-latex-inline-default-scale "1"
  "default scale for inline formular")

;; the color of the equation is defined in case that I use a
;; background other than white in my HTML page.
(setq muse-latex2png-template
      "\\documentclass{article}
\\usepackage{fullpage}
\\usepackage{amssymb}
\\usepackage[usenames]{color}
\\usepackage{amsmath}
\\usepackage{latexsym}
\\usepackage[mathscr]{eucal}
%preamble%
\\pagestyle{empty}
\\begin{document}
{%code%}
\\end{document}\n")

(defun kid-muse-html-latex (beg end attrs)
  (let* ((scale (cdr (assoc "scale" attrs)))
	 (muse-latex2png-scale-factor
	  (if scale
	      (string-to-number scale)
	      muse-latex2png-scale-factor)))
    (muse-publish-latex-tag beg end attrs)))
(defun kid-muse-html-latex-inline ()
  (let ((attrs `(("scale" . ,kid-muse-html-latex-inline-default-scale)
		 ("inline" . "true"))))
    (kid-muse-html-latex (match-beginning 0) (match-end 0) attrs)))

(setq muse-latex2png-scale-factor 1.5)
(require 'muse-colors)
(add-to-list 'muse-colors-tags
	     '("latex" t t nil muse-colors-example-tag))

