;; compile hot-key
(global-set-key [(f9)] 'compile)

;; add include guards
(defun cpp-add-include-guard ()
  "Add an include guard to the current header file"
  (interactive)
  (defun list-to-string (list c)
    (let (
  (res (car list))
  )
      (dolist (subword (cdr list))
(setq res (concat res c subword)))
      res)
    )
  (setq
   filename
   (list-to-string
    (split-string
     (upcase (buffer-name))
     "[.]")
    "_")
   )
  (push-mark)
  (goto-char (point-min))
  (let ((frm "%s __%s__\n"))
    (insert (format frm "#ifndef" filename))
    (insert (format frm "#define" filename))
    )
  (goto-char (point-max))
  (insert "\n#endif\n")
  )

(defun cpp-swap-header-source ()
  "Switch to corresponding C/C++ header/source"
  (interactive)
  (defun switch-to-conj-buffer (init-buffer-name)
    (defun get-conj-extension (extension)
      (defun is-in-list (list str)
(if (not list) nil
  (if (equal (car list) str)
      t
    (is-in-list (cdr list) str))))
      (let (
    (src-ext '("cpp" "c" "cxx"))
    (hdr-ext '("h" "hpp"))
    )
(cond ((is-in-list src-ext extension) hdr-ext)
      ((is-in-list hdr-ext extension) src-ext)
      (t nil))))
    (defun switch-to-existing-buffer (bare-name ext-list)
      (if (not ext-list) nil
(setq next-name (concat bare-name "." (car ext-list)))
(if (get-buffer next-name) (switch-to-buffer next-name)
  (switch-to-existing-buffer bare-name (cdr ext-list)))))
    (defun split-name (name) (car (split-string name "[.][^.]+$")))
    (defun split-ext (name) (nth 1 (split-string name "^.+[.]")))
    (switch-to-existing-buffer
     (split-name init-buffer-name)
     (get-conj-extension (split-ext init-buffer-name))))
  (if (switch-to-conj-buffer (buffer-name))
      (message "Couldn't find buffer"))
  )
