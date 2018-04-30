;;; Emacs Config
;; by Dieter Brehm

;; place custom lisp code here
(add-to-list 'load-path "~/.emacs.d/custom-lisp")

;; improve startup time
(setq-default file-name-handler-alist nil
              gc-cons-threshold 402653184
							gc-cons-percentage 0.6)

;; misc
(setq c-default-style "linux"
      c-basic-offset 4
      sgml-basic-offset 4)
(c-set-offset `inline-open 0)
(setq-default tab-width 2)

;; Install Melpa
(require 'package)
(setq-default package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                                 ("melpa" . "https://melpa.org/packages/")
                                 ("org" . "https://orgmode.org/elpa/"))
              package-enable-at-startup nil
							load-prefer-newer t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
	(package-install 'use-package))

;; set font
(set-face-attribute 'default t :font "Consolas 11")

;; global show whitespace
(setq-default show-trailing-whitespace t)
(savehist-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)
(global-linum-mode t)
(delete-selection-mode 1)

;; when using fill-paragraph or fill-region or auto-fill, set desired width
(setq-default fill-column 80)

;; don't just throw temp files everywhere please
(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; don't show scroll bars
(toggle-scroll-bar -1)

;; how many lines to move when scrolling
(setq scroll-step 1)

;; default find file path for windows
(if (eq system-type 'ms-dos)
		(progn
			(set (setq default-directory "C:\\Users\\dieterbrehm\\"))))

;; turn all yes or no's to y's or n's
(fset 'yes-or-no-p 'y-or-n-p)

;; org for organizational tool
(use-package org :ensure
  :config
  (global-set-key (kbd "C-c c") 'org-capture)
  (setq org-todo-keywords
		'((sequence "TODO" "DONE")))
  (setq org-agenda-files '("~/Dropbox/OrgFiles"))
  (setq org-default-notes-file "~/Dropbox/OrgFiles/notes.org")
  (setq org-log-done 'time)
  (setq org-log-into-drawer "LOGBOOK")
  (setq org-clock-into-drawer 1)
	(setq org-src-fontify-natively t)
	(setq
	 org-agenda-custom-commands
	 '(("c" "composite agenda view"
			((agenda "")
			 (tags "Art"
             ((org-agenda-overriding-header "Artistic Tasks")
              (org-tags-match-list-sublevels nil)))
			 (tags "+Olin+Misc"
						 ((org-agenda-overriding-header "Misc Olin Related Tasks")
              (org-tags-match-list-sublevels nil)))
			 )))
	 ;; only show entries schedules for the current day
	 org-agenda-span 'day)

	(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)))

;; replace bullets with cool looking unicode symbols
;;(require 'org-bullets)
;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; a new regularly spaced font
'(variable-pitch ((t (:family "Arial" :height 160))))

;; function allowing for monospace and variable-pitched fonts in one buffer,
;; for instance in a org-mode buffer with code documentation.
(defun set-buffer-variable-pitch ()
	(interactive)
	(variable-pitch-mode t)
	(setq line-spacing 3)
	(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
	(set-face-attribute 'org-code nil :inherit 'fixed-pitch)
	(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
	(set-face-attribute 'org-block-background nil :inherit 'fixed-pitch))

;; all the modes where I want to have variable pitch
(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
(add-hook 'eww-mode-hook 'set-buffer-variable-pitch)
(add-hook 'markdown-mode-hook 'set-buffer-variable-pitch)
(add-hook 'Info-mode-hook 'set-buffer-variable-pitch)

;; function for removing new lines in region
;; useful for alterting the region-fill column size of a region
;; after the fact
(defun replace-newlines-in-region ()
	"Removes all newlines in the selected region and replace with spaces."
	(interactive)
	(save-restriction
		(narrow-to-region (point) (mark))
		(goto-char (point-min))
		(while (search-forward "\n" nil t) (replace-match " " nil t))))

;; default python package
(use-package python)

;; Smarter buffer management
(use-package ibuffer :ensure
  :bind ("C-x C-b" . ibuffer)
  :config
  (autoload 'ibuffer "ibuffer" "List Buffers." t))

;; company = complete-any, a completion backend
(use-package company :ensure
  :config
  (add-hook 'prog-mode-hook 'company-mode)
  (setq company-idle-delay 0.1)
  (bind-key "<C-tab>" 'company-manual-begin))

;; sort company completions by usage stats
(use-package company-statistics :ensure
  :config
  (company-statistics-mode))

;; backend server for javascript autocompletion and linting
(use-package tern
  :config
  (bind-key "C-c C-c" 'compile tern-mode-keymap)
  (when (eq system-type 'windows-nt) (setq tern-command '("cmd" "/c" "tern")))
  (add-hook 'js2-mode-hook 'tern-mode))

;; company front-end for tern javascript completion
(use-package company-tern :ensure
  :config
  (add-to-list 'company-backends 'company-tern)
  (setq company-tern-property-marker "*")
  (add-hook 'js2-mode-hook (lambda () (tern-mode t))))

;; snippets
(yas-global-mode 1)
(use-package yasnippet-snippets :ensure)

;; strings representing colors get highlighted with that color
(use-package rainbow-mode :ensure)

;; pretty-print json
(use-package json-mode :ensure)

;; make highlighting and working with javascript much better
(use-package js2-mode :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

;; package for "zen-coding" html and css elements
(use-package emmet-mode :ensure
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode))

;; allow mixed syntax highlighting for web templating usage
(use-package web-mode :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

;; syntax for markdown, essential for Readme files
(use-package markdown-mode :ensure
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; A convenient filetree
(use-package neotree :ensure
  :bind ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'ascii 'arrow))) ; make the left-side markers pretty

;; simplifies the management of undo's
(use-package undo-tree :ensure
  :config
  (bind-key "M-/" 'undo-tree-visualize)
  (global-undo-tree-mode))

;; (displays possible commands in a minibuffer when a leader key is pressed)
(use-package which-key :ensure
  :config
  (which-key-mode))

;; git client for emacs
(use-package magit :ensure
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

;;  Ivy completion framework
(use-package ivy :ensure
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

;;;;; Stuff for ivy
(use-package swiper :ensure
  :bind ("C-s" . swiper))

;;;;; better M-x autocomplete
(use-package smex :ensure
  :config
  (global-set-key [remap execute-extended-command] 'smex)
  )

;;;;; Stuff for ivy
(use-package counsel :ensure)

;;;;; plaintext organizational tool
(use-package deft :ensure
  :config
  (setq deft-extensions '("txt" "tex" "org"))
  (setq deft-directory "~/Dropbox/OrgFiles")
  (setq deft-recursive t))

;;;;; A fancy mode line
(use-package smart-mode-line :ensure
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful))

(use-package olivetti :ensure)

;;;;; A nice dark theme. Contains several sub options
(use-package base16-theme :ensure
  :config
  (load-theme 'base16-default-dark t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 (quote
		( use-package)))
 '(ring-bell-function (quote ignore)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)
