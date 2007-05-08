;;;; my emms customization
;;; setup emms
(add-to-list 'load-path
	     (expand-file-name "~/emacs/packages/emms")
	     t)

(require 'emms-source-file)
(require 'emms-source-playlist)
(require 'emms-player-simple)
(require 'emms-player-mplayer)
(require 'emms-playlist-mode)
(require 'emms-info)
(require 'emms-cache)
(require 'emms-mode-line)
(require 'emms-playing-time)
(require 'emms-score)
(require 'emms-volume)

(setq emms-playlist-default-major-mode 'emms-playlist-mode)
(add-to-list 'emms-track-initialize-functions 'emms-info-initialize-track)
(add-to-list 'emms-info-functions 'kid-emms-info-simple)
(setq emms-track-description-function 'kid-emms-info-track-description)
(when (fboundp 'emms-cache)
  (emms-cache 1))

(setq emms-player-list
      '(emms-player-mplayer
	emms-player-mpg321
	emms-player-ogg123))

(setq emms-info-asynchronously nil)
(setq emms-playlist-buffer-name "*Music*")
;; use faster finding facility if you have GNU find
(setq emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)

;;; My musics
(setq emms-source-file-default-directory "~/entertainment/music")

(add-hook 'emms-player-started-hook 'emms-show)

;; mode line format
(setq emms-mode-line-format "[ %s "
      emms-playing-time-display-format "%s ]")
(setq global-mode-string
      '("" emms-mode-line-string " " emms-playing-time-string))
	
;;; key customization
;; global key-map
(global-set-key (kbd "s-x") 'emms-playlist-mode-go)

(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e x") 'emms-start)
(global-set-key (kbd "C-c e v") 'emms-stop)
(global-set-key (kbd "C-c e n") 'emms-next)
(global-set-key (kbd "C-c e p") 'emms-previous)
(global-set-key (kbd "C-c e o") 'emms-show)
(global-set-key (kbd "C-c e h") 'emms-shuffle)
(global-set-key (kbd "C-c e e") 'emms-play-file)
(global-set-key (kbd "C-c e f") 'emms-play-playlist)
(global-set-key (kbd "C-c e SPC") 'emms-pause)
(global-set-key (kbd "C-c e a") 'emms-add-directory-tree)

(global-set-key (kbd "C-c e r")   'emms-toggle-repeat-track)
(global-set-key (kbd "C-c e R")   'emms-toggle-repeat-playlist)

(global-set-key (kbd "C-c e s u") 'emms-score-up-playing)
(global-set-key (kbd "C-c e s d") 'emms-score-down-playing)
(global-set-key (kbd "C-c e s o") 'emms-score-show-playing)
;; playlist-mode-map
(define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)
(define-key emms-playlist-mode-map (kbd "+") 'emms-volume-raise)
(define-key emms-playlist-mode-map (kbd "-") 'emms-volume-lower)
(define-key emms-playlist-mode-map (kbd "<right>")
  (lambda () (interactive) (emms-seek +10)))
(define-key emms-playlist-mode-map (kbd "<left>")
  (lambda () (interactive) (emms-seek -10)))
(define-key emms-playlist-mode-map (kbd "<up>")
  (lambda () (interactive) (emms-seek +60)))
(define-key emms-playlist-mode-map (kbd "<down>")
  (lambda () (interactive) (emms-seek -60)))
(define-key emms-playlist-mode-map (kbd "S u") 'emms-score-up-file-on-line)
(define-key emms-playlist-mode-map (kbd "S d") 'emms-score-down-file-on-line)
(define-key emms-playlist-mode-map (kbd "S o") 'emms-score-show-file-on-line)
(define-key emms-playlist-mode-map (kbd "S l") 'emms-score-less-tolerant)
(define-key emms-playlist-mode-map (kbd "S m") 'emms-score-more-tolerant)
(define-key emms-playlist-mode-map (kbd "S t") 'emms-score-set-tolerance)
(define-key emms-playlist-mode-map (kbd "S s") 'emms-score-show-playing)
(define-key emms-playlist-mode-map (kbd "a f") 'emms-add-file)
(define-key emms-playlist-mode-map (kbd "a d") 'emms-add-directory)
(define-key emms-playlist-mode-map (kbd "a t") 'emms-add-directory-tree)

;;; My functions
(defun kid-emms-info-simple (track)
  "Get info from the filename.
mp3 标签的乱码问题总是很严重，幸好我系统里面的音乐文件
都放得比较有规律，所以我决定直接从文件名获取标签信息。"
  (when (eq 'file (emms-track-type track))
    (let ((regexp "/\\([^/]+\\)/\\([^/]+\\)\\.[^.]+$")
	  (name (emms-track-name track)))
      (if (string-match regexp name)
	  (progn
	    (emms-track-set track 'info-artist (match-string 1 name))
	    (emms-track-set track 'info-title (match-string 2 name)))
	  (emms-track-set track 
			  'info-title
			  (file-name-nondirectory name))))))
(defun kid-emms-info-track-description (track)
  "Return a description of the current track."
  (let ((artist (emms-track-get track 'info-artist))
	(title (emms-track-get track 'info-title)))
    (format "%-10s +| %s" 
	    (or artist
		"")
	    title)))

(defun emms ()
  "start emms and begin to play the default playlist"
  (interactive)
  (emms-play-playlist (expand-file-name "~/entertainment/music/playlist/emms")))
