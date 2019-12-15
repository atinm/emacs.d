(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(setq org-directory "~/Documents/orgfiles")
(setq org-default-notes-file (concat org-directory "/capture.org"))
(setq org-startup-indented 5)
(global-set-key "\C-c l" 'org-store-link)
(global-set-key "\C-c a" 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(provide 'init-org)
