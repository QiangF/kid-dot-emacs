;;;; my version control config

;; 加载 psvn
(require 'psvn)

;; 加载 git
(require 'git)
(add-to-list 'vc-handled-backends 'GIT)
