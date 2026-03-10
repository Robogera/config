(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package emacs
  :demand t
  :ensure nil
  :init
  (load-theme 'leuven t)

	(setq use-package-always-defer t)
	(setq use-package-compute-statistics t)
	(setq use-package-hook-name-suffix nil)

  ;; Turn this shi off
  (global-unset-key (kbd "<f10>"))
  (setq use-dialog-box nil) 
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq inhibit-startup-message t)

	;; Vim-esque
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ;; Force good tabs everywhere
  (setq indent-tabs-mode t)
  (setq-default tab-width 2)

  (setq make-backup-files nil) ; TODO: maybe move to a directory in $HOME
  (setq auto-save-default nil)
  (setq create-lockfiles nil)

  (global-display-line-numbers-mode 1)
  (setq display-line-numbers-type 'relative)
  (setq-default display-line-numbers-width 3)

  (setq scroll-conservatively 1000
    scroll-margin 10)

  (set-frame-font "Terminus 12" nil t)
  (setq enable-recursive-minibuffers t)
  (setq frame-inhibit-implied-resize t)

  (setq sentence-end-double-space nil) 
  (setq show-trailing-whitespace t)

  ;; IDK if I even need this
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
          coding-system-for-read 'utf-8
          coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq native-comp-async-report-warnings-errors nil)
  (setq load-prefer-newer t)

  (show-paren-mode t))

(use-package org-inlinetask
	:commands
	  org-inlinetask-insert-task
	:config
	  (message "org-inlinetask loaded!"))

(use-package eshell
	:commands eshell
  :init
	(setq eshell-visual-commands '())
	(setq eshell-visual-subcommands '())
	(setq eshell-visual-options '())
  (setq eshell-scroll-to-bottom-on-input t)
  (setq eshell-history-size 10000)
  (setq eshell-save-history-on-exit t)
  (setq eshell-hist-ignoredups t))

(use-package esh-module
	:after eshell
  :config
  (add-to-list 'eshell-modules-list 'eshell-tramp))

(use-package openwith
	:ensure t
	:hook dired-load-hook
	:config
  (setq openwith-associations
    '(("\\.\\(?:cb[rtz]\\|djvu\\|p\\(?:df\\|s\\)\\)$" "zathura" (file))
      ("\\.\\(?:gif\\|jp\\(?:e?g\\)\\|png\\|svg\\|tiff\\|webp\\)$" "swayimg" (file))
			("\\.\\(?:docx?\\|od[fpst]\\|pptx?\\|xlsx?\\)$" "libreoffice --norestore --nologo" (file))
      ("\\.\\(?:avi\\|m\\(?:kv\\|p\\(?:4\\|eg\\)\\)\\)$" "mpv" (file)))))

(use-package eat
	:ensure t
	:defer t
	:demand nil
	:commands eat
  :hook ((eshell-load-hook . eat-eshell-mode)
				 (eat-exec-hook . (lambda (_) (eat-char-mode))))
  :config
	(setq eat-term-name "xterm-256color"))

(use-package evil
	:ensure t
  :demand t
  :config
  (evil-mode 1)
  (setq evil-shift-width 2)
  (evil-define-key 'normal          'global (kbd "SPC b p") 'previous-buffer)
  (evil-define-key 'normal          'global (kbd "SPC b n") 'next-buffer)
  (evil-define-key 'normal          'global (kbd "SPC b x") 'kill-current-buffer)
  (evil-define-key '(normal visual) 'global (kbd "SPC c c") 'comment-line)
  (evil-define-key 'normal          'global (kbd "SPC c a") 'comment-indent)
  (evil-define-key '(normal visual) 'global (kbd "SPC c k") 'comment-kill)
  (evil-define-key '(normal visual) 'global (kbd "SPC c b") 'comment-box)

  (evil-define-key 'visual 'global (kbd "<") 
    (lambda ()
      (interactive)
      (call-interactively 'evil-shift-left)
      (evil-normal-state)
      (evil-visual-restore)))

  (evil-define-key 'visual 'global (kbd ">") 
    (lambda ()
      (interactive)
      (call-interactively 'evil-shift-right)
      (evil-normal-state)
      (evil-visual-restore)))
  )

(use-package avy
	:ensure t
	:after evil
  :bind (:map evil-normal-state-map
          ("s" . avy-goto-line)
          ("S" . avy-goto-word-0)))

(use-package company
	:ensure t
	:after evil
	:bind (:map evil-insert-state-map
				   ("C-n" . company-complete)
				 :map company-active-map
				   ("<tab>" . nil)
				   ("<ret>" . nil)
				   ("<escape>" . company-abort)
				   ("C-y" . company-complete-selection))
	:config (setq company-idle-delay nil))

(use-package dired
  :config
	(defvar dired-dedicated-other-window nil
		"A window marked to display files opened in dired.")

	(defun dired-find-file-chosen-window (&optional focus)
		"Opens a file in a remembered window or creates one if necessary. Switches focus if optional arg is not nil."
		(interactive)
		(if (not (window-valid-p dired-dedicated-other-window)) 
			(setq dired-dedicated-other-window (or (window-in-direction 'below)
																					 	 (window-in-direction 'right)
																						 (next-window)
																						 (split-window-vertically))))
		(set-window-buffer dired-dedicated-other-window (find-file-noselect (dired-get-file-for-visit)))
		(if focus (select-window dired-dedicated-other-window)))

  (keymap-set dired-mode-map "o" 'dired-find-file-chosen-window)
  (keymap-set dired-mode-map "C-o" (lambda () (interactive) (dired-find-file-chosen-window t))))

(use-package eglot
  :config
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

(use-package git-gutter
	:ensure t
	:bind (:map evil-normal-state-map
				   ("SPC h h" . git-gutter)
				   ("SPC h p" . git-gutter:popup-hunk)
				   ("SPC h s" . git-gutter:stage-hunk)
				   ("SPC h r" . git-gutter:revert-hunk)
				   ("SPC h m" . git-gutter:mark-hunk)
				   ("[ c" . git-gutter:previous-hunk)
				   ("] c" . git-gutter:next-hunk)
				 :map evil-visual-state-map
				   ("[ c" . git-gutter:previous-hunk)
				   ("] c" . git-gutter:next-hunk))
  :config
  (set-face-foreground 'git-gutter:modified "orange")
  (set-face-foreground 'git-gutter:added "green")
  (set-face-foreground 'git-gutter:deleted "red")
  (setq git-gutter:update-interval 0.66)
  (setq git-gutter:modified-sign "▌")
  (setq git-gutter:added-sign "▌")
  (setq git-gutter:deleted-sign "▌")
	(git-gutter:start-update-timer))

;; Custom's stuff

(custom-set-variables)
(custom-set-faces)
