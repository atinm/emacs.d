(use-package company
  :init
  (setq company-idle-delay nil  ; avoid auto completion popup, use TAB
                                ; to show it
        company-tooltip-align-annotations t)
  :hook (after-init . global-company-mode)
  :bind
  (:map prog-mode-map
        ("C-i" . company-indent-or-complete-common)
        ("C-M-i" . completion-at-point)))

(use-package company-lsp
  :defer)

(use-package lsp-mode
  :commands lsp
  ;; reformat code and add missing (or remove old) imports
  :hook ((before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)
	 (python-mode . lsp))
  :bind (("C-c d" . lsp-describe-thing-at-point)
         ("C-c e n" . flymake-goto-next-error)
         ("C-c e p" . flymake-goto-prev-error)
         ("C-c e r" . lsp-find-references)
         ("C-c e R" . lsp-rename)
         ("C-c e i" . lsp-find-implementation)
         ("C-c e t" . lsp-find-type-definition)))

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

;; Sentinel function for capturing ctags
(defun ctags-process-callback (process event)
  "Show status of asynchronous ctags-process after it finishes."
  (cond
   ((string-equal event "finished\n")
    (message "Creating tag files...completed")
    (kill-buffer (get-buffer "*ctags*"))
    (visit-tags-table (format "%sTAGS" (projectile-project-root))))
   (t
    (message "Creating tags file...failed")
    (pop-to-buffer (get-buffer "*ctags*"))
    )))

;; General variable for executing Ctags
(setq ctags-refresh-command
      (format "ctags -e -R -f %sTAGS %s."
              (projectile-project-root) (projectile-project-root)))

(defun refresh-ctags ()
  "Refresh ctags according to currently set command."
  (interactive)

  (message "Starting ctags process")
  (start-process-shell-command "ctags" "*ctags*" ctags-refresh-command)
  (set-process-sentinel (get-process "ctags") 'ctags-process-callback))

;; Ctags bindings
(define-key prog-mode-map (kbd "C-c E") 'refresh-ctags)

(eval-after-load "etags"
  '(progn
     (ac-etags-setup)))

(provide 'init-programming-modes)
