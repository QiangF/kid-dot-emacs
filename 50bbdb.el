;;;; bbdb configuration
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/bbdb/lisp/")
	     t)

(require 'bbdb)
(bbdb-initialize 'gnus 'message 'sendmail)

(setq bbdb-north-american-phone-numbers-p nil)

(setq bbdb-user-mail-names
      (regexp-opt '("pluskid.zju@gmail.com"
		    "pluskid@zju.edu.cn"
		    "pluskid@mstczju.org"
		    "05jzgjzcy@st.zju.edu.cn")))

(setq bbdb-complete-name-allow-cycling t)
(setq bbdb-use-pop-up nil)
