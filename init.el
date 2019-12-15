;; .emacs.d/init.el

;; Add user's lisp directories
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))

;; ===================================
;; Allow access from emacsclient
;; ===================================
(require 'server)
(unless (server-running-p)
  (server-start))

;; ===================================
;; MELPA Package Support
;; ===================================

;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

(setq use-package-always-ensure nil)
(require 'use-package)

;; Installs packages
;;

;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    solarized-theme                 ;; Theme
    flycheck
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


;; ===================================
;; Basic Customization
;; ===================================
(setq inhibit-startup-message t)    ;; Hide the startup message
(setq-default initial-major-mode 'org-mode) ;; make *scratch* be org-mode
(setq-default initial-scratch-message nil) ;; make *scratch* empty
(setq-default major-mode 'org-mode) ;; make org-mode the default mode

;; ===================================
;; Solarized Configuration Overrides
;; ===================================
(defun solarized-customizations ()
  ;; make the fringe stand out from the background
  (setq solarized-distinct-fringe-background t)
  
  ;; Don't change the font for some headings and titles
  (setq solarized-use-variable-pitch nil)
  
  ;; make the modeline high contrast
  (setq solarized-high-contrast-mode-line t)
  
  ;; Use less bolding
  (setq solarized-use-less-bold t)
  
  ;; Use more italics
  (setq solarized-use-more-italic t)
  
  ;; Use less colors for indicators such as git:gutter, flycheck and similar
  (setq solarized-emphasize-indicators nil)
  
  ;; Don't change size of org-mode headlines (but keep other size-changes)
  (setq solarized-scale-org-headlines nil)
  
  ;; Avoid all font-size changes
  (setq solarized-height-minus-1 1.0)
  (setq solarized-height-plus-1 1.0)
  (setq solarized-height-plus-2 1.0)
  (setq solarized-height-plus-3 1.0)
  (setq solarized-height-plus-4 1.0)
)

(solarized-customizations)
(load-theme 'solarized-light t)     ;; Load solarized-light theme

(global-linum-mode t)               ;; Enable line numbers globally
(setq make-backup-files nil)        ;; turn off automatic backup~ file

;; flx matching
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(require 'init-projectile)
(require 'init-org)
(require 'init-neotree)
(require 'init-ido)
(require 'init-tags)

;; =======================================
;; Set up programming modes
;; =======================================
(require 'init-programming-modes)
(require 'init-go)
(require 'init-python)
(require 'init-ruby)

;; User-Defined init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(package-selected-packages
   (quote
    (enh-ruby-mode projectile neotree ac-etags company-lsp lsp-ui gnu-elpa-keyring-update spinner lsp-mode flx-ido company-inf-ruby rvm robe py-autopep8 elpy flycheck company-go go-guru go-eldoc go-mode solarized-theme material-theme better-defaults)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
