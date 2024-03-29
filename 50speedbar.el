;;;; My speedbar configuration
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/speedbar-0.14beta4"))

(require 'speedbar)

;; make speedbar shown in the same frame
(defconst my-speedbar-buffer-name "SPEEDBAR")
(defun my-speedbar-no-separate-frame ()
  (interactive)
  (when (not (buffer-live-p speedbar-buffer))
    (setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
	  speedbar-frame (selected-frame)
	  dframe-attached-frame (selected-frame)
	  speedbar-select-frame-method 'attached
	  speedbar-verbosity-level 0
	  speedbar-last-selected-file nil)
    (set-buffer speedbar-buffer)
    (speedbar-mode)
    (speedbar-reconfigure-keymaps)
    (speedbar-update-contents)
    (speedbar-set-timer 1)
    (make-local-hook 'kill-buffer-hook)
    (add-hook 'kill-buffer-hook
	      (lambda () (when (eq (current-buffer) speedbar-buffer)
			   (setq speedbar-frame nil
				 dframe-attached-frame nil
				 speedbar-buffer nil)
			   (speedbar-set-timer nil)))))
  (set-window-buffer (selected-window) 
		     (get-buffer my-speedbar-buffer-name)))
(defun kid-toggle-speedbar ()
  (interactive)
  (if (window-live-p (get-buffer-window my-speedbar-buffer-name))
      (progn				; hide speedbar
	(delete-window (get-buffer-window speedbar-buffer)))
      (progn
	(split-window-horizontally -25)
	(other-window 1)
	(my-speedbar-no-separate-frame))))
(global-set-key (kbd "<f12>") 'kid-toggle-speedbar)
