(defun my-ido-find-tag ()
    "Find a tag using ido"
    (interactive)
    (tags-completion-table)
    (let (tag-names)
      (mapcar (lambda (x)
                  (push (prin1-to-string x t) tag-names))
                tags-completion-table)
      (find-tag (ido-completing-read "Tag: " tag-names))))

(global-set-key (kbd "C-c M-.") 'my-ido-find-tag)

(provide 'init-ido)
