(defun my-go-electric-brace ()
  "Insert an opening brace may be with the closing one.
If there is a space before the brace also adds new line with
properly indented closing brace and moves cursor to another line
inserted between the braces between the braces."
  (interactive)
  (if (not (looking-back " "))
      (insert "{")
    (insert "{")
    (newline)
    (indent-according-to-mode)
    (save-excursion
      (newline)
      (insert "}")
      (indent-according-to-mode))))

(defun my-go-list-packages ()
  "Return list of Go packages."
  (split-string
   (with-temp-buffer
     (shell-command "go list ... 2>/dev/null" (current-buffer))
     (buffer-substring-no-properties (point-min) (point-max)))
   "\n"))

(defun my-godoc-package ()
  "Display godoc for given package (with completion)."
  (interactive)
  (godoc (helm :sources (helm-build-sync-source "Go packages"
                          :candidates (my-go-list-packages))
               :buffer "*godoc packages*")))

(use-package go-eldoc
  :defer)

(use-package flycheck
  :defer)

(use-package company-go
  :defer)

(use-package go-guru
  :defer)

(use-package go-mode
  :init
  (setq gofmt-command "goimports"     ; use goimports instead of gofmt
        go-fontify-function-calls nil ; fontifing names of called
                                      ; functions is too much for me
        company-idle-delay nil)
  :config
  (require 'go-guru)
  :bind
  (:map go-mode-map
   ("M-." . go-guru-definition)
   ("C-c d" . godoc-at-point)
   ("C-c g" . godoc)
   ("C-c h" . go-guru-hl-identifier)
   ("C-c P" . my-godoc-package)
   ("{" . my-go-electric-brace)
   ("C-i" . company-indent-or-complete-common)
   ("C-M-i" . company-indent-or-complete-common))
  :config
  ;; run gofmt/goimports when saving the file
  (add-hook 'before-save-hook #'gofmt-before-save)

  (defun my-go-mode-hook-fn ()
    (go-eldoc-setup)
    (set (make-local-variable 'company-backends) '(company-go))
    (company-mode)
    (smartparens-mode 1)
    (flycheck-mode 1)
    (setq imenu-generic-expression
          '(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
            ("func" "^func *\\(.*\\) {" 1))))

  (add-hook 'go-mode-hook #'my-go-mode-hook-fn))

;; Go/speedbar integration

(eval-after-load 'speedbar
  '(speedbar-add-supported-extension ".go"))

(defun create-go-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "cd %s; /usr/local/bin/ctags -R --output-format=etags --languages=go --exclude=.git --exclude=log -f %s/TAGS %s $(bundle list --paths)" (directory-file-name dir-name) (directory-file-name dir-name) (directory-file-name dir-name)))
    (visit-tags-table (format "%s/TAGS" (directory-file-name dir-name))))

(global-set-key (kbd "C-c g t") 'create-go-tags)

(add-hook 'go-mode-common-hook 'ac-etags-ac-setup)

(provide 'init-go)
