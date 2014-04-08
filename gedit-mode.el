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
    (forward-line -1)
    (current-indentation)))

(define-minor-mode gedit-mode
  "a mode for gedit user"
  :global t :group 'gedit
  (set (make-local-variable 'indent-line-function) 'gedit-indent-line))

(provide 'gedit-mode)
