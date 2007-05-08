;;;; my smart-snippet config
(require 'smart-snippet)

;;; for c++-mode
(require 'cc-mode)
(smart-snippet-with-abbrev-table 'c++-mode-abbrev-table
  ("if" "if ($${condition})\n{$>\n$>$.\n}$>" 'bol?)
  ("for" "for ($${init}; $${cond}; $${step})\n{$>\n$>$.\n}$>" 'bol?))
