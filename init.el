;;; Emacs Config
;; by Dieter Brehm
;; updated 2022

;; place custom lisp code here
(add-to-list 'load-path "~/.emacs.d/custom-lisp")

 (defun markdown-convert-buffer-to-org ()
    "Convert the current buffer's content from markdown to
orgmode format and save it with the current buffer's file name
but with .org extension."
    (interactive)
    (shell-command-on-region (point-min) (point-max)
                             (format "pandoc -f markdown -t org -o %s"
                                     (concat (file-name-sans-extension (buffer-file-name)) ".org"))))
;; misc
(setq c-default-style "linux"
      c-basic-offset 2
      sgml-basic-offset 2)
(c-set-offset `inline-open 0)
(setq-default tab-width 2)
(setq visible-bell t)

;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Install Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(setq-default package-enable-at-startup nil
							load-prefer-newer t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
	(package-install 'use-package))

(if (eq system-type 'darwin)
		(progn
			(set-face-attribute 'default t :font "Monaco 12")))
	    ;; (set-face-attribute 'default t :font "iA Writer Mono S")))

;; global show whitespace
;; (setq-default show-trailing-whitespace t)
(savehist-mode 1)

;; highlight current line
;; (global-hl-line-mode +1)

;; highlight parens
(show-paren-mode 1)

;; make sure paths play nice in Mac OS
(use-package exec-path-from-shell :ensure)

;; make emacs obey shell path
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; show where we are horizontally
(column-number-mode 1)

;; turn off the tool bar
(tool-bar-mode -1)

;; show line numbers in any programming mode
;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; we want pandoc in org and markdown
(use-package pandoc-mode :ensure
	:config
	(add-hook 'pandoc-mode 'org-mode)
	(add-hook 'pandoc-mode 'markdown-mode))

;; delete stuff like a sane person
(delete-selection-mode 1)

;; when using fill-paragraph or fill-region or auto-fill, set desired width
(setq-default fill-column 80)

;; don't just throw temp files everywhere please
(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; don't show scroll bars
(toggle-scroll-bar -1)

;; ;; how many lines to move when scrolling
;; (setq scroll-step 1)

;; default find file path for windows
(if (eq system-type 'ms-dos)
		(progn
			(set (setq default-directory "C:\\Users\\dieterbrehm\\"))))

;; turn all yes or no's to y's or n's
(fset 'yes-or-no-p 'y-or-n-p)

;; smart project detection, jumping, and management
(use-package projectile :ensure
	:config
  (projectile-global-mode)
	(setq projectile-completion-system 'ivy))

(use-package counsel-projectile :ensure)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; startup splash for emacs
(use-package dashboard :ensure
	:config
	(dashboard-setup-startup-hook)
	;; Set the title
	(setq dashboard-startup-banner nil)
	(setq dashboard-banner-logo-title "Welcome to Emacs Dashboard")
	;; Set the banner
	(setq dashboard-set-footer nil)
	;; Value can be
	;; 'official which displays the official emacs logo
	;; 'logo which displays an alternative emacs logo
	;; 1, 2 or 3 which displays one of the text banners
	;; "path/to/your/image.png which displays whatever image you would prefer
	(setq dashboard-item '((recents . 5)
												 (bookmarks . 5)
												 (projects . 5)
												 (agenda . 5))))

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
	)

;; all the modes where I want to have variable pitch
(add-hook 'org-mode-hook 'set-buffer-variable-pitch)
(add-hook 'eww-mode-hook 'set-buffer-variable-pitch)
(add-hook 'markdown-mode-hook 'set-buffer-variable-pitch)
(add-hook 'Info-mode-hook 'set-buffer-variable-pitch)

;;; Install epdfinfo via 'brew install pdf-tools' and then install the
;;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
;;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
;;; pdf-tools package using Emacs package system. If things get messed
;;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
;;; pdf-tools package and reinstall both as at the start.
(use-package pdf-tools
  :ensure t
  :config
  (custom-set-variables
    '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
(pdf-tools-install)

(defun writing-mode ()
  (interactive)
  (setq buffer-face-mode-face '(:family "iA Writer Duo S" :height 150))
  (buffer-face-mode)
  (linum-mode 0)
  ;; (writeroom-mode 1)
	(olivetti-mode 1)
	(setq show-trailing-whitespace nil)
  (blink-cursor-mode)
	;; '(writeroom-fullscreen-effect (quote maximized))
  (visual-line-mode 1)
  (setq truncate-lines nil)
  (setq-default line-spacing 5)
  (setq global-hl-line-mode nil))

'(olivetti-body-width 80)
'(olivetti-lighter "")

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

;; arduino  packages
(use-package platformio-mode :ensure)
(use-package arduino-mode :ensure)
(add-to-list 'auto-mode-alist '("\\.ino$" . arduino-mode))
(add-hook 'c++-mode-hook (lambda ()
                           (lsp)
                           (platformio-conditionally-enable)))

;; language servers for code introspection
;; adds a ton of completion and debugging features
;; to setup for js: *npm install -g javascript-typescript-langserver*
;; to setup for python: *pip install python-language-server*
;; (use-package lsp-mode :ensure
  ;; :commands lsp)

;; extra visual features and goodies
;; for language servers
;; (use-package lsp-ui :ensure
	;; :commands lsp-ui-mode)

;; c++ language servers
;; requires the install of ccls,
;; *brew install ccls* works on mac.
;; you have to build it on linux
;; (use-package ccls :ensure
;; 	:config
;; 	;;'(ccls-initialization-options (quote (compilationDatabaseDirectory :build)))
;;   :hook ((c-mode c++-mode objc-mode) .
;; 				 (lambda () (require 'ccls) (lsp))))

;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection "ccls")
;;                   :major-modes '(c-mode c++-mode)
;;                   :server-id 'ccls))


;; syntax highlighting for vue.js
(use-package vue-mode :ensure
	:config
	(add-hook 'mmm-mode-hook
          (lambda ()
						(set-face-background 'mmm-default-submode-face nil))))

;; apple's swift programming language
(use-package swift-mode :ensure)

;; company hook in to language servers
;; (use-package company-lsp :ensure
;; 	:commands company-lsp)

;; company = complete-any, a completion backend
(use-package company :ensure
  :config
  (add-hook 'prog-mode-hook 'company-mode)
	(add-hook 'markdown-mode-hook 'company-mode)
	(add-hook 'tex-mode 'company-mode)
  (setq company-idle-delay 0.1)
  (bind-key "<C-tab>" 'company-manual-begin)
	(add-to-list 'company-backends 'company-dabbrev t)
	(add-to-list 'company-backends 'company-dabbrev-code t))

;; sort company completions by usage stats
(use-package company-statistics :ensure
  :config
  (company-statistics-mode))

;; company for latex math
(use-package company-math :ensure
	:config
	(add-to-list 'company-backends 'company-math-symbols-unicode)
	(add-to-list 'company-backends 'company-latex-commands)
	(add-to-list 'company-backends 'company-math-symbols-latex))

(add-to-list 'company-backends 'company-ispell)

;; snippets
(use-package yasnippet :ensure)

(yas-global-mode 1)

(use-package yasnippet-snippets :ensure)

;; strings representing colors get highlighted with that color
(use-package rainbow-mode :ensure)

;; pretty-print json
(use-package json-mode :ensure)

(use-package emmet-mode :ensure)

(use-package web-mode :ensure
	:config
	(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
	(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
	(add-hook 'web-mode-hook  'emmet-mode))


;; syntax highlighting for sass
(use-package sass-mode :ensure

	:config
	(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode)))

;; syntax for markdown, essential for Readme files
(use-package markdown-mode :ensure
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; simplifies the management of undo's
(use-package undo-tree :ensure
  :config
  (bind-key "M-/" 'undo-tree-visualize)
  (global-undo-tree-mode))

(use-package ispell :ensure
	:config
	(bind-key "M-~" 'ispell-complete-word)
	(global-set-key "\M-~" 'ispell-complete-word))

(add-hook 'flyspell-mode-hook
          (lambda ()
            "Use ispell to corrent the word instead of flyspell's."
            (define-key flyspell-mode-map (kbd "C-M-i") 'ispell-complete-word)))

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

;; Stuff-searcher for ivy
(use-package swiper :ensure
  :bind ("C-s" . swiper-isearch))

;; Stuff-selector for ivy
(use-package counsel :ensure)

;; Make ivy work better with projectile
(use-package counsel-projectile :ensure)

;; better smex ;)
(use-package amx :ensure
	:config
	(amx-mode))

;; A fancy mode line
(use-package smart-mode-line :ensure
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful))

;; A nice dark theme. Contains several sub options
;; (use-package base16-theme :ensure
;; 	:config
;;   (load-theme 'base16-monokai t))

;; the monokai theme
;; (use-package monokai-theme :ensure
;;  	:config
;;  	(load-theme 'monokai t))

;; a pretty good light theme
(use-package solarized-theme :ensure
	:config
 	(load-theme 'solarized-light t))

;; solarized pdf-tools midnight coloring
'(pdf-tools-handle-upgrades nil)
 '(pdf-view-midnight-colors (quote ("#839496" . "#fdf6e3")))

;; (use-package  hydandata-light-theme :ensure
;; 	:config
;; 	(load-theme 'hydandata-light t))

;; https://stackoverflow.com/questions/6954479/emacs-tramp-doesnt-work
;;(require 'tramp-sh nil t)
;;(setf tramp-ssh-controlmaster-options (concat "-o SendEnv TRAMP=yes " tramp-ssh-controlmaster-options))
;;(setq tramp-default-method "ssh")

;; oh, you want some vim *in* emacs
(use-package evil :ensure)

;; variable text centering
;; for focused writting
(use-package olivetti :ensure)

;; LaTeX mode
(use-package auctex
	:defer t
	:ensure t
	:config
	(setq TeX-auto-save t)
	(setq TeX-parse-self t)
	(setq TeX-save-query nil))

;; spelling correction
(use-package flyspell
	:config
	(add-hook 'text-mode-hook 'flyspell-mode))

;; emojis in text modes
(use-package emojify
	:config
	(add-hook 'text-mode-hook 'emojify-mode))

(use-package lua-mode)

(use-package )

;;;;; rss feed viewer
;(use-package elfeed :ensure)

;;;;; pipe rss feed urls in org file to elfeed
;(use-package elfeed-org :ensure
;	:config
;	(elfeed-org)
;	(setq rmh-elfeed-org-files (list "~/Dropbox/OrgFiles/rss.org")))

;(use-package elfeed-goodies :ensure
;	:config
;	(elfeed-goodies/setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   '("67481d84a9d5cb8de661e05592928efb4c149e05e6d63d36714d9443b3946265" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "eae831de756bb480240479794e85f1da0789c6f2f7746e5cc999370bbc8d9c8a" "36746ad57649893434c443567cb3831828df33232a7790d232df6f5908263692" "8c1dd3d6fdfb2bee6b8f05d13d167f200befe1712d0abfdc47bb6d3b706c3434" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "46720e46428c490e7b2ddeafc2112c5a796c8cf4af71bd6b758d5c19316aff06" "cabc32838ccceea97404f6fcb7ce791c6e38491fd19baa0fcfb336dcc5f6e23c" "ed4c48eb91d07c2e447b445e2491ef17e9b326d43a60022297fd56af4749e772" "9c4acf7b5801f25501f0db26ac3eee3dc263ed51afd01f9dcfda706a15234733" "146061a7ceea4ccc75d975a3bb41432382f656c50b9989c7dc1a7bb6952f6eb4" "e6a9337674f6c967311b939bb4f81aefb65a96908c3749f4dd8d4500f6d79242" "819d24b9aba8fcb446aecfb59f87d1817a6d3eb07de7fdec67743ef32194438b" "1d079355c721b517fdc9891f0fda927fe3f87288f2e6cc3b8566655a64ca5453" "760ce657e710a77bcf6df51d97e51aae2ee7db1fba21bbad07aab0fa0f42f834" "34ed3e2fa4a1cb2ce7400c7f1a6c8f12931d8021435bad841fdc1192bd1cc7da" "325979cd5043662dfe95e2cb68e9ff47c7f8ca088a2b463da5d049cc76a65f3b" "732ccca2e9170bcfd4ee5070159923f0c811e52b019106b1fc5eaa043dff4030" "c968804189e0fc963c641f5c9ad64bca431d41af2fb7e1d01a2a6666376f819c" "9be1d34d961a40d94ef94d0d08a364c3d27201f3c98c9d38e36f10588469ea57" default))
 '(fci-rule-color "#eee8d5")
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   '("#efe4da49afb1" "#cfc4e1acd08b" "#fe52c9e6b34e" "#dbb6d3c2dcf3" "#e183dee0b053" "#f944cc6dae47" "#d35fdac4e069"))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   '(("#eee8d5" . 0)
     ("#b3c34d" . 20)
     ("#6ccec0" . 30)
     ("#74adf5" . 50)
     ("#e1af4b" . 60)
     ("#fb7640" . 70)
     ("#ff699e" . 85)
     ("#eee8d5" . 100)))
 '(hl-bg-colors
   '("#e1af4b" "#fb7640" "#ff6849" "#ff699e" "#8d85e7" "#74adf5" "#6ccec0" "#b3c34d"))
 '(hl-fg-colors
   '("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3"))
 '(hl-paren-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(lsp-ui-doc-border "#586e75")
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4"))
 '(olivetti-lighter "")
 '(package-selected-packages
   '(lua-mode poly-R polymode ag web-mode emmet-mode imenu-list aggressive-indent modus-operandi-theme pdf-tools writeroom-mode forge dimmer hydandata-light-theme vagrant-tramp pandoc-mode base16-theme amx hledger-mode emojify solarized-theme solarized monokai-theme processing-mode ess 0blayout flycheck-swiftlint swift-mode vue-mode ccls arduino-mode platformio-mode exec-path-from-shell use-package))
 '(pdf-tools-handle-upgrades nil)
 '(pdf-view-midnight-colors '("#839496" . "#fdf6e3"))
 '(pos-tip-background-color "#eee8d5")
 '(pos-tip-foreground-color "#586e75")
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(weechat-color-list
   '(unspecified "#fdf6e3" "#eee8d5" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#657b83" "#839496")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "nil" :slant normal :weight normal :height 141 :width normal)))))
