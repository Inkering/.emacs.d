;;; Emacs Config
;;;; indentation
(setq c-default-style "linux"
      c-basic-offset 4
      sgml-basic-offset 4)
(c-set-offset `inline-open 0)
(setq-default tab-width 4)

;;;; misc
(setq-default show-trailing-whitespace t)
(savehist-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)
(global-linum-mode t)
(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
(toggle-scroll-bar -1)

;;; Packages
;;;; Install Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(setq quelpa-update-melpa-p nil)
(unless (require 'quelpa nil t)
  (with-temp-buffer
	(url-insert-file-contents "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")
	(eval-buffer)))

;;;; install quelpa-use-package, it's handy
(quelpa 'quelpa-use-package)
(require 'quelpa-use-package)

;;;; Internal Packages

;;;;; org for organizational tool
(use-package org
  :config
  (setq org-todo-keywords
		'((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (setq org-agenda-files '("~/Dropbox/OrgFiles"))
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)))

(use-package python)

;;;;; Smarter buffer management
(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config
  (autoload 'ibuffer "ibuffer" "List Buffers." t))

;;;;; Auto completion in a few specific modes/languages
(use-package semantic
  :defer
  :init
  (add-hook 'c-mode-hook 'semantic-mode)
  :config
  (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                    global-semanticdb-minor-mode
                                    global-semantic-decoration-mode
                                    global-semantic-highlight-func-mode
                                    global-semantic-show-unmatched-syntax-mode
                                    global-semantic-idle-summary-mode
                                    global-semantic-stickyfunc-mode
                                    global-semantic-idle-local-symbol-highlight-mode)
        semantic-idle-scheduler-idle-time 0.2)

  ; inhibit semantic outside of specific modes
  (setq semantic-inhibit-functions
        #'(lambda () (not (member major-mode '(c-mode cc-mode java-mode)))))

  (eval-after-load "cc-mode"
    '(define-key c-mode-map (kbd "M-.") 'semantic-ia-fast-jump)))

;;;; External Packages

;;;;; Lots and lots of auto completion configurations
(use-package company :ensure
  :config
  (global-company-mode)
  (setq company-idle-delay 0.1)
  (bind-key "<C-tab>" 'company-manual-begin))

(use-package company-jedi :ensure          ;;; company-mode completion back-end for Python JEDI
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (setq jedi:use-shortcuts t)
  (defun config/enable-company-jedi ()
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'config/enable-company-jedi))

(use-package company-c-headers :ensure
  :config
  (add-to-list 'company-backends 'company-c-headers))

(use-package company-statistics :ensure
  :config
  (company-statistics-mode))

;;;;; python dev tools
(use-package elpy :ensure
  :config
  (elpy-enable)
  (setq elpy-rpc-python-command "/Users/dieterbrehm/anaconda/bin/python3.5")
  (setq python-shell-interpreter "/Users/dieterbrehm/anaconda/bin/python3.5"))

;;;;;Web dev tools
(use-package rainbow-mode :ensure)

(use-package json-mode :ensure)

(use-package scss-mode :ensure
  :config
  (setq exec-path (cons (expand-file-name "~/.gem/ruby/2.0.0/cache/") exec-path))
  (autoload 'scss-mode "scss-mode")
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode)))

(use-package emmet-mode :ensure
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode))

;;;;; syntax for markdown, essential for Readme files
(use-package markdown-mode :ensure
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;;;; A convenient filetree
(use-package neotree :ensure
  :bind ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'ascii 'arrow)))

;;;;;simplifies the management of undo's
(use-package undo-tree :ensure
  :config
  (bind-key "M-/" 'undo-tree-visualize)
  (global-undo-tree-mode))

;;;;; How the heck to I remember all these keybindings??
(use-package which-key :ensure
  :config
  (which-key-mode))

(use-package ledger-mode :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.journal\\'" . ledger-mode))
  (setq ledger-mode-should-check-version nil)
  (setq ledger-report-links-in-register nil)
  (setq ledger-binary-path "hledger"))

;;;;; git integration
(use-package magit :ensure
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

;;;;; Ivy completion framework
(use-package ivy :ensure
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

;;;;; Stuff for ivy
(use-package swiper :ensure)

;;;;; Stuff for ivy
(use-package counsel :ensure)

;;;;; A fancy mode line
(use-package smart-mode-line :ensure
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful))

;;;;; A nice dark theme. Contains several sub options
(use-package base16-theme :ensure
  :config
  (load-theme 'base16-default-dark t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
	("~/Dropbox/OrgFiles/precitech.org" "~/Dropbox/OrgFiles/peterpap.org")))
 '(package-selected-packages
   (quote
	(ledger-mode markdown-mode company-c-headers company-jedi magit undo-tree quelpa-use-package)))
 '(python-shell-interpreter "/Users/dieterbrehm/anaconda/bin/python3.5"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
