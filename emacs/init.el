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
  (load-theme 'modus-vivendi t)
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
  (evil-define-key '(normal visual) 'global (kbd "s") 'avy-goto-word-0))

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
