(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
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

(setq use-package-always-ensure t)

(use-package emacs
  :demand t
  :ensure nil
  :init
  ;; (load-theme 'modus-operandi-tinted t)
  (setq tab-width 2)
  (setq make-backup-files nil) ; TODO: maybe move to a directory in $HOME
  (setq auto-save-default nil)
  (setq-default display-line-numbers-width 4)
  (setq scroll-conservatively 1000
    scroll-margin 10)
  (global-unset-key (kbd "<f10>"))
  (setq use-dialog-box nil) 
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq inhibit-startup-message t)
  (setq display-line-numbers-type 'relative)
  (global-display-line-numbers-mode 1)
  (set-frame-font "Terminus 12" nil t)
  (setq enable-recursive-minibuffers t)
  (setq sentence-end-double-space nil) 
  (setq frame-inhibit-implied-resize t) ;; useless for a tiling window manager
  (setq show-trailing-whitespace t) ;; self-explanatory
  (setq indent-tabs-mode nil) ;; no tabs
  ; (setq create-lockfiles nil) ;; no need to create lockfiles

  (set-charset-priority 'unicode) ;; utf8 everywhere
  (setq locale-coding-system 'utf-8
          coding-system-for-read 'utf-8
          coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  (global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;; escape quits everything

  (setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
  (setq native-comp-async-report-warnings-errors nil)
  (setq load-prefer-newer t)

  (show-paren-mode t))

(use-package vterm
  :demand t
  :ensure t
  :init
  (setq vterm-max-scrollback 10000)
  (setq vterm-timer-delay 0.001))

(use-package eat
  :demand t
  :ensure t
  :config
  (add-hook 'eat-exec-hook
    (lambda (_) (eat-char-mode)))
  (add-hook 'eshell-mode-hook  #'eat-eshell-mode)
  (add-hook 'eshell-mode-hook  #'eat-eshell-visual-command-mode))

(use-package evil
  :demand t
  :ensure t
  :init
  (require 'evil)
  (evil-mode 1)
  (evil-define-key '(normal) 'global (kbd "g c") 'comment-dwim)
  (evil-define-key '(normal visual) 'global (kbd "s") 'avy-goto-word-0)
  (evil-define-key '(normal visual) 'global (kbd "S") 'avy-goto-line))

(use-package avy
  :demand t
  :ensure t)
  
(use-package eshell
  :demand t
  :ensure nil
  :init
  (setq eshell-scroll-to-bottom-on-input t)
  (setq eshell-history-size 10000)
  (setq eshell-save-history-on-exit t)
  (setq eshell-hist-ignoredups t))

(use-package esh-module
  :demand t
  :ensure nil
  :defer t
  :config
  (add-to-list 'eshell-modules-list 'eshell-tramp))

(use-package evil-leader
  :demand t
  :ensure t
  :config
  (evil-leader/set-leader "<SPC>")
  (global-evil-leader-mode)
  (evil-leader/set-key "bx" 'kill-current-buffer)
  (evil-leader/set-key "bp" 'previous-buffer)
  (evil-leader/set-key "bn" 'next-buffer))

(use-package dired
  :demand t
  :ensure nil
  :config
  (defun dired-window () (window-at (frame-width) 1))
  (eval-after-load 'dired
    '(define-key dired-mode-map (kbd "C-o")
      (lambda ()
      (interactive)
      (let ((dired-window (dired-window)))
        (set-window-buffer dired-window
          (find-file-noselect 
          (dired-get-file-for-visit)))))))
  (eval-after-load 'dired
    '(define-key dired-mode-map (kbd "o")
      (lambda ()
      (interactive)
      (let ((dired-window (dired-window)))
        (set-window-buffer dired-window
          (find-file-noselect 
          (dired-get-file-for-visit)))
        (select-window dired-window))))))

(use-package tramp
  :demand t
  :ensure nil
  :config
  (setq tramp-default-method "sshx"))

(use-package inhibit-mouse
  :ensure t
  :custom
  (inhibit-mouse-adjust-mouse-highlight t)
  (inhibit-mouse-adjust-show-help-function t)
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
    (inhibit-mouse-mode 1)))

(use-package git-gutter
  :demand t
  :ensure t
  :after evil-leader
  :init
  (evil-define-key '(normal visual) 'global (kbd "[c") 'git-gutter:previous-hunk)
  (evil-define-key '(normal visual) 'global (kbd "]c") 'git-gutter:next-hunk)
  (evil-leader/set-key "hh" 'git-gutter)
  (evil-leader/set-key "hp" 'git-gutter:popup-hunk)
  (evil-leader/set-key "hs" 'git-gutter:stage-hunk)
  (evil-leader/set-key "hr" 'git-gutter:revert-hunk)
  (evil-leader/set-key "hm" 'git-gutter:mark-hunk))

(use-package eglot
  :demand t
  :ensure nil
  :init
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

(use-package company
  :demand t
  :ensure t
  :hook
  (after-init . global-company-mode))

(use-package alabaster-themes
  :ensure t
  :config
  (load-theme 'alabaster-themes-dark t))

(custom-set-variables
 '(custom-safe-themes
   '("01f6946488b7d6f6857e58b2372527b7bd1b63910f38123e72cf00e4c9651895"
     default)))
(custom-set-faces)
