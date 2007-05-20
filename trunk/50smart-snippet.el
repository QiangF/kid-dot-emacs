;;;; my smart-snippet config
(require 'smart-snippet)
(setq save-abbrevs nil)

;;; for c++-mode
(require 'cc-mode)
(smart-snippet-with-abbrev-table 'c++-mode-abbrev-table
  ("if" "if ($${condition})\n{$>\n$>$.\n}$>" 'bol?)
  ("elsif" "else if ($${condition})\n{$>\n$>$.\n}$>" 'bol?)
  ("else" "else\n{$>\n$>$.\n}$>" 'bol?)
  ("for" "for ($${init}; $${cond}; $${step})\n{$>\n$>$.\n}$>" 'bol?)
  ("namespace" "namespace $${name} {\n$.\n} // namespace $${name}" 'bol?))

;; those non-word snippet can't be triggered by abbrev expand, we
;; need to bind them explicitly to some key
(smart-snippet-with-abbrev-table 'c++-mode-abbrev-table
  ("{" "{$>\n$>$.\n}$>" 'bol?)
  ;; if not in comment or other stuff(see `c-in-literal'), then
  ;; inser a pair of quote. if already in string, insert `\"'
  ("\"" "\"$.\"" '(not (c-in-literal)))	
  ("\"" "\\\"$." '(eq (c-in-literal) 'string))
  ;; insert a pair of parenthesis, useful everywhere
  ("(" "($.)" t)
  ;; insert a pair of angular bracket if we are writing templates
  ("<" "<$.>" '(and (not (c-in-literal))
			 (looking-back "template[[:blank:]]*")))
  ;; a pair of square bracket, also useful everywhere
  ("[" "[$.]" t)
  ;; a pair of single quote, if not in literal
  ("'" "'$.'" '(not (c-in-literal)))
  )

(smart-snippet-with-keymap c++-mode-map 'c++-mode-abbrev-table
  ("{" "{")
  ("\"" "\"")
  ("(" "(")
  ("<" "<")
  ("[" "[")
  ("'" "'")
  )
