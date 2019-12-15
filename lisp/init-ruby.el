(require 'ruby-mode)

(defun activate-ruby-mode ()
  "All things for ruby mode."

  ;; Set specific ctags command
  (setq-local ctags-refresh-command
              (format "ctags -e -R --languages=ruby -f %sTAGS %s. $(bundle list --paths)"
                      (projectile-project-root) (projectile-project-root))))

(add-hook 'enh-ruby-mode-hook 'activate-ruby-mode)
(add-hook 'ruby-mode-common-hook 'ac-etags-ac-setup)

(provide 'init-ruby)
