; a mode for gedit user
(defun gedit-indent-line ()
  "indent current line as gedit mode"
  (interactive)
  (if (< (current-column) (current-indentation))
    (move-to-column (current-indentation)))
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
        ; zero means forward success
        (eq 0 (forward-line -1))
        (current-line-blank-p)))
    (current-indentation)))

(defun current-line-blank-p ()
  "is current line blank ?"
  (string-match "^[ \t]*$"
    ; thing-at-point will return an additional newline character
    (substring
      (thing-at-point 'line)
      0 -1)))

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
    (define-key map "\C-j" 'newline-and-indent)
    (define-key map "\C-m" 'newline)
    map)
  "Keymap for gedit mode.")

(define-minor-mode gedit-mode
  "a mode for gedit user"
  :global t :group 'gedit
  (if gedit-mode
    (progn
      (set (make-local-variable 'indent-line-function) #'gedit-indent-line))))

(defvar gedit-mode-enable-mode-list
  '(
    python-mode
    coffee-mode
    ))

(defun gedit-mode-maybe ()
  "enable gedit-mode"
  (if (member major-mode gedit-mode-enable-mode-list)
    (gedit-mode t)))

(define-global-minor-mode global-gedit-mode
  gedit-mode gedit-mode-maybe
  :group 'gedit)

(provide 'gedit-mode)
