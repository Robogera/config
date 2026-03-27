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
  ;; (load-theme 'leuven t)
  (setq use-package-always-defer t)
  (setq use-package-compute-statistics t)
  (setq use-package-hook-name-suffix nil)

  ;; Turn this shi off
  (global-unset-key (kbd "<f10>"))
  (setq use-dialog-box nil) 
  (menu-bar-mode -1)
  ;; (tool-bar-mode -1)
  ;; (scroll-bar-mode -1)
  (setq inhibit-startup-message t)

  ;; Vim-esque
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ;; Force good tabs everywhere
  (setq indent-tabs-mode nil)
  (setq-default tab-width 2)

  (setq make-backup-files nil) ; TODO: maybe move to a directory in $HOME
  (setq auto-save-default nil)
  (setq create-lockfiles nil)

  ;; (global-display-line-numbers-mode 1)
  ;; (setq display-line-numbers-type 'relative)
  ;; (setq-default display-line-numbers-width 3)

  (setq scroll-conservatively 1000
    scroll-margin 10)

  (set-frame-font "Terminus 12" nil t)
  (setq enable-recursive-minibuffers t)
  (setq frame-inhibit-implied-resize t)

  (setq sentence-end-double-space nil) 

  ;; IDK if I even need this
  ;; (set-charset-priority 'unicode)
  ;; (setq locale-coding-system 'utf-8
  ;;         coding-system-for-read 'utf-8
  ;;         coding-system-for-write 'utf-8)
  ;; (set-terminal-coding-system 'utf-8)
  ;; (set-keyboard-coding-system 'utf-8)
  ;; (set-selection-coding-system 'utf-8)
  ;; (prefer-coding-system 'utf-8)
  ;; (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  ;; (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq native-comp-async-report-warnings-errors t)
  (setq load-prefer-newer t)

	(setq default-input-method 'russian-computer)

  (show-paren-mode t))

(use-package meow
	:ensure t
	:demand t
	:config
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
	 '("w j" . windmove-down)
	 '("w k" . windmove-up)
	 '("w h" . windmove-left)
	 '("w l" . windmove-right)
	 '("w J" . windmove-swap-states-down)
	 '("w K" . windmove-swap-states-up)
	 '("w H" . windmove-swap-states-left)
	 '("w L" . windmove-swap-states-right)
	 '("w v" . split-window-right)
	 '("w s" . split-window-below)
	 '("w q" . delete-window)
	 '("b p" . next-buffer)
	 '("b n" . previous-buffer)
	 '("b b" . switch-to-buffer)
	 '("b l" . ibuffer)
	 '("b r" . rename-buffer)
	 '("b x" . kill-current-buffer)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore))
	(meow-global-mode 1)
 )

(use-package org-inlinetask
  :commands
    org-inlinetask-insert-task
  :config
    (message "org-inlinetask loaded!"))

(use-package eshell
  :commands eshell
	:hook
  (eshell-mode-hook . (lambda () (display-line-numbers-mode -1)))
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

(use-package tramp
	:config
	(setq tramp-use-connection-share nil))

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

(use-package avy
  :ensure t
	:commands avy-goto-word-1
  :init
	(meow-motion-define-key
	 '("F" . avy-goto-word-1))
	(meow-normal-define-key
	 '("F" . avy-goto-word-1)))

(use-package vertico
	:hook
	(minibuffer-mode-hook . vertico-mode-enable-once)
  :init
  ;; (load-theme 'leuven t)
  (defun vertico-mode-enable-once () (vertico-mode) (message "Enabling vertico...") (remove-hook 'minibuffer-mode-hook #'vertico-mode-enable-once ))
	:ensure t)

(use-package corfu-terminal
	:bind
	;; (:map evil-insert-state-map
	;; 			("C-n" . completion-at-point)
	;; 			:map corfu-map
	;; 			("C-y" . corfu-complete))
	:config
	(global-corfu-mode)
	:ensure t)

(use-package dired
  :config
  (defvar dired-dedicated-other-window nil
    "A window marked to display files opened in dired.")

  (defun dired-mark-selected-window-as-chosen ()
    "Marks currently selected window as preferred for dired"
    (interactive)
    (setq dired-dedicated-other-window (or (selected-window) dired-dedicated-other-window)))

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

  ;; (keymap-set evil-normal-state-map "SPC d m" 'dired-mark-selected-window-as-chosen)
  (keymap-set dired-mode-map "-" 'dired-up-directory)
  (keymap-set dired-mode-map "o" 'dired-find-file-chosen-window)
  (keymap-set dired-mode-map "C-o" (lambda () (interactive) (dired-find-file-chosen-window t))))

(use-package eglot
  :config
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

(use-package almost-mono-themes
	:ensure t
	:init
	(load-theme 'almost-mono-gray t))

(use-package diff-hl-mode
  :ensure
  (:host github :repo "dgutov/diff-hl" :main "diff-hl.el")
  :hook
  (dired-mode-hook . diff-hl-dired-mode)
  (vc-dir-mode-hook . turn-on-diff-hl-mode)
  :bind
  ;; (:map evil-normal-state-map
  ;; ("SPC h r" . diff-hl-revert-hunk)
  ;; ("SPC h s" . diff-hl-show-hunk)
  ;; ("SPC h h" . diff-hl-mode))
  :config
  (diff-hl-flydiff-mode))

;; Custom's stuff

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
	 '("623e9fe0532cc3a0bb31929b991a16f72fad7ad9148ba2dc81e395cd70afc744"
		 "0f691b0fef27fdeffb52131f21914b6819044659c785109060dbfb72d6b38246"
		 default))
 '(org-agenda-files
	 '("~/.org/work/avo-megaschool-service.org"
		 "/home/gera/.org/work/org.org"
		 "/home/gera/.org/work/school-tr-26-lan.org")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
