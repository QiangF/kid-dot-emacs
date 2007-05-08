;;;; mail utilities

;; use fortune.el to make my signature
(require 'fortune)
(setq fortune-dir "~/.fortune")
(setq fortune-file "~/.fortune")
(setq fortune-sigstart "pluskid\n")
(add-hook 'message-signature-setup-hook 'fortune-to-signature)
