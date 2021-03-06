;;; .emacs -- my emacs config
;;; Commentary:
;; Author: Andre Almar

;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("MELPA" . "https://melpa.org/packages/") t)
(package-initialize)

;; Use the value of $PATH constructed at shell's creation
;; (done only when emacs started with window-system)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set-exec-path-from-shell-PATH ()
    (let ((path-from-shell (replace-regexp-in-string
                                "[ \t\n]*$"
                                ""
                (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
                (setenv "PATH" path-from-shell)
                (setq eshell-path-env path-from-shell) ; for eshell users
                (setq exec-path (split-string path-from-shell path-separator))
        )
)
(when window-system (set-exec-path-from-shell-PATH))

;; use standard keys for undo cut copy paste
(cua-mode 1)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; fixing yaml
(use-package highlight-numbers
  :hook ((prog-mode yaml-mode) . highlight-numbers-mode))

;;;
;;; Packages
;;;
;;(use-package exec-path-from-shell
;;  :ensure t
;;  :config (exec-path-from-shell-initialize))

(use-package iedit
  :ensure t)

(use-package windmove
  ;; :defer 4
  :ensure t
  :config
  ;; use command key on Mac
  ;;(windmove-default-keybindings 'super)
  ;; use command key on Linux
  (windmove-default-keybindings 'meta)
  ;; wrap around at edges
  (setq windmove-wrap-around t))

(use-package org
  :ensure t
  :bind (("<f6>" . org-agenda)
         ("<f7>" . org-capture))
  :config
  (progn
    (setq org-directory "~/org"
          org-agenda-files '("~/org/todo.org.gpg")
          ;; org-agenda-file-regexp ""
          org-agenda-todo-ignore-scheduled 'future
          org-agenda-tags-todo-honor-ignore-options t
          org-refile-allow-creating-parent-nodes (quote confirm)
          org-refile-targets (quote ((org-agenda-files :maxlevel . 2)))
          org-refile-use-outline-path t
          org-log-done 'time
          org-log-into-drawer t
          org-startup-indented t
          org-default-notes-file "~/org/todo.org.gpg"
          org-src-fontify-natively t
          org-use-speed-commands t
          org-capture-templates
          '(("m" "Measures" plain
             (file+datetree+prompt "~/org/measures.org.gpg")
             (file "~/org/capture-templates/measure.txt"))
            ("t" "To-do" entry
             (file "~/org/todo.org.gpg")
             "* TODO %?\n  %i\n%a %u")
            ))
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)))
    (use-package org-habit)))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq indo-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(defalias 'list-buffers 'ibuffer)

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

(use-package counsel
  :ensure t)

;;; Docker packages
(use-package dockerfile-mode
  :ensure t)

(use-package projectile
  :ensure t
  :config (projectile-mode)
  :diminish projectile-mode)

(use-package select-themes
  :init (setq custom-safe-themes t)
  :ensure t)

(use-package ido
  :ensure t
  :init
  (progn
    (ido-mode 1)
    (use-package ido-vertical-mode
      :ensure t
      :init (ido-vertical-mode 1)
      :config (setq ido-vertical-define-keys 'C-n-and-C-p-only))
    (use-package smex
      :ensure t
      :init (smex-initialize)
      :bind (("M-x" . smex)
             ("M-X" . smex-major-mode-commands))
)))

;;; Most IMPORTANT package of my Emacs config
(use-package nyan-mode
  :ensure t
  :config
  (progn
    (setq nyan-animate-nyancat nil
          nyan-wavy-trail t)
    (nyan-mode)
(nyan-start-animation)))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package ace-window
  :ensure t
  :bind (("M-m" . ace-window)))

(use-package flycheck
  :ensure t
:init (global-flycheck-mode))

(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-tooltip-flip-when-above t
        company-show-numbers t)
  :diminish company-mode)

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

  (add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))

;;;
;;; Options
;;;

(setq inhibit-startup-message t)
(setq package-enable-at-startup nil)
(setq make-backup-files nil)
(column-number-mode t)
(delete-selection-mode t)
(show-paren-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;; Clear the eshell buffer.
 (defun eshell/clear ()
    (let ((eshell-buffer-maximum-lines 0)) (eshell-truncate-buffer)))

;; recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; allow commands
(put 'narrow-to-region 'disabled nil)

;;;
;;; Theme and styling
;;;
(use-package spacemacs-theme
  :ensure t
  :config (load-theme 'spacemacs-dark t))

;;;
;;; Theme and style
;;;
(add-hook 'after-init-hook (lambda () (load-theme 'spacemacs-dark)))
(set-face-attribute 'default nil :height 120 :family "mononoki")

;;;
;;; save autosave files in /tmp folder
;;;
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;; hideshow
(add-hook 'prog-mode-hook #'hs-minor-mode)
(eval-after-load 'hideshow
  '(progn
     (global-set-key (kbd "C-+") 'hs-toggle-hiding)))

;; Fix all indentation
(defun fix-indentation ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;;; .emacs ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#E8E8E8" "#3C3C3C" "#616161" "#0E0E0E" "#252525" "#3C3C3C" "#171717" "#0E0E0E"])
 '(eshell-output-filter-functions
   (quote
    (eshell-handle-control-codes eshell-handle-ansi-color eshell-watch-for-password-prompt)))
 '(fci-rule-color "#171717")
 '(global-linum-mode t)
 '(package-selected-packages
   (quote
    (dockerfile-mode docker highlight-numbers spacemacs-theme flymake-go go-mode go elnode kubernetes-evil flymake-yaml flycheck-elixir helm-company alchemist kaolin-themes eshell-prompt-extras eshell-git-prompt gitlab-ci-mode-flycheck flycheck-gometalinter nlinum color-identifiers-mode flycheck-yamllint yaml-mode go-autocomplete company-go yasnippet which-key use-package try tao-theme smex select-themes pyenv-mode py-isort projectile org-bullets nyan-mode markdown-mode magit iedit ido-vertical-mode flycheck counsel company-anaconda auto-complete ace-window)))
 '(vc-annotate-background "#0E0E0E")
 '(vc-annotate-color-map
   (quote
    ((20 . "#616161")
     (40 . "#9E9E9E")
     (60 . "#9E9E9E")
     (80 . "#C3C3C3")
     (100 . "#C3C3C3")
     (120 . "#DADADA")
     (140 . "#DADADA")
     (160 . "#E8E8E8")
     (180 . "#E8E8E8")
     (200 . "#E8E8E8")
     (220 . "#F1F1F1")
     (240 . "#F1F1F1")
     (260 . "#F1F1F1")
     (280 . "#F6F6F6")
     (300 . "#F6F6F6")
     (320 . "#F6F6F6")
     (340 . "#FAFAFA")
     (360 . "#FAFAFA"))))
 '(vc-annotate-very-old-color "#DADADA"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
