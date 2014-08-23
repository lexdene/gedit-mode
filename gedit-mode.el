; a mode for gedit user
(defun gedit-indent-line ()
  "indent current line as gedit mode"
  (interactive)
  (indent-to (gedit-calculate-indent)))

(defun gedit-calculate-indent ()
  "calculate the indent column"
  (let (
        (current-indent (current-indentation))
        (previous-indent (previous-line-indentation)))
    (if (< current-indent previous-indent)
      ;then
      previous-indent
      ;else
      (+ tab-width current-indent))))

(defun previous-line-indentation ()
  "calculate the indentation of previous line"
  (save-excursion
    (while
      (and
        (eq 0 (forward-line -1))
        (eq 0 (current-indentation))))
    (current-indentation)))

(defun gedit-unindent-command ()
  "unindent current line"
  (interactive)
  (let (
        (current-indent (current-indentation)))
    (delete-horizontal-space)
    (indent-to (- current-indent tab-width))))

(defvar gedit-mode-map
  (let ((map (make-sparse-keymap)))
    ;; key bindings
    (define-key map (kbd "<backtab>") 'gedit-unindent-command)
    map)
  "Keymap for gedit mode.")

(define-minor-mode gedit-mode
  "a mode for gedit user"
  :global t :group 'gedit
  (if gedit-mode
    (progn
      (use-local-map gedit-mode-map)
      (setq indent-line-function 'gedit-indent-line))))

(defun gedit-mode-maybe ()
  "enable gedit-mode"
  (gedit-mode t))

(define-global-minor-mode global-gedit-mode
  gedit-mode gedit-mode-maybe
  :group 'gedit)

(provide 'gedit-mode)
