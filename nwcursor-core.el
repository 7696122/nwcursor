;;; nwcursor-core.el --- new window cursor for emacs.
;; 
;; Filename: nwcursor-core.el
;; Description: 
;; Author: 7696122 
;; Maintainer: 7696122
;; Created: Mon Oct 31 12:18:13 2016 (+0900)
;; Version: 
;; Package-Requires: ()
;; Last-Updated: 
;;           By: 
;;     Update #: 0
;; URL: 
;; Doc URL: 
;; Keywords: cursor
;; Compatibility: 
;; 
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

(defgroup nwcursor nil
  "Displaying text cursors in nox"
  :prefix "nwc/"
  :group 'display)

(defvar saved-origin-cursor 'cursor-type
  "Remembered original cursor type.")

;; prefix
(defcustom nwc/tmux-escape-code-prefix "\ePtmux;\e"
  "Prefix of escape code for tmux"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/escape-code-prefix "\e["
  "Prefix of escape code."
  :type 'string
  :group 'nwcursor)

;; suffix
(defcustom nwc/escape-code-suffix " q"
  "Suffix of escape code."
  :type 'string
  :group 'nwcursor)

(defcustom nwc/tmux-escape-code-suffix "\e\\"
  "Suffix of escape code for tmux"
  :type 'string
  :group 'nwcursor)

;; body
(defcustom nwc/blink-box-escape-code "1"
  "Blink filled box cursor"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/box-escape-code "2"
  "filled box cursor"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/blink-hbar-escape-code "3"
  "blink horizontal bar cursor"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/hbar-escape-code "4"
  "horizontal bar cursor"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/blink-bar-escape-code "5"
  "blink vertical bar cursor"
  :type 'string
  :group 'nwcursor)

(defcustom nwc/bar-escape-code "6"
  "vertical bar cursor"
  :type 'string
  :group 'nwcursor)

(defvar nwc/escape-code-blink-box-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/blink-box-escape-code
          nwc/escape-code-suffix))

(defvar nwc/escape-code-box-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/box-escape-code
          nwc/escape-code-suffix))

(defvar nwc/escape-code-blink-hbar-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/blink-hbar-escape-code
          nwc/escape-code-suffix))

(defvar nwc/escape-code-hbar-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/hbar-escape-code
          nwc/escape-code-suffix))

(defvar nwc/escape-code-blink-bar-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/blink-bar-escape-code
          nwc/escape-code-suffix))

(defvar nwc/escape-code-bar-cursor
  (format "%s%s%s"
          nwc/escape-code-prefix
          nwc/bar-escape-code
          nwc/escape-code-suffix))

(defvar nwc/tmux-escape-code-blink-box-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-blink-box-cursor
          nwc/tmux-escape-code-suffix))

(defvar nwc/tmux-escape-code-box-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-box-cursor
          nwc/tmux-escape-code-suffix))

(defvar nwc/tmux-escape-code-blink-hbar-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-blink-hbar-cursor
          nwc/tmux-escape-code-suffix))

(defvar nwc/tmux-escape-code-hbar-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-hbar-cursor
          nwc/tmux-escape-code-suffix))

(defvar nwc/tmux-escape-code-blink-bar-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-blink-bar-cursor
          nwc/tmux-escape-code-suffix))

(defvar nwc/tmux-escape-code-bar-cursor
  (format "%s%s%s"
          nwc/tmux-escape-code-prefix
          nwc/escape-code-bar-cursor
          nwc/tmux-escape-code-suffix))

(defun nwc/set-cursor ()
  "echo -ne %s"
  (interactive)
  (send-string-to-terminal 
   (let ((nwc/type
          (if (listp cursor-type)
              (car cursor-type)
            cursor-type)))
     (cond ((or (eq nwc/type 'box)
                (eq nwc/type 'hollow))
            (if (nwc/in-tmux?)
                (if blink-cursor-mode
                    nwc/tmux-escape-code-blink-box-cursor
                  nwc/tmux-escape-code-box-cursor)
              (if blink-cursor-mode
                  nwc/escape-code-blink-box-cursor
                nwc/escape-code-box-cursor)))
           ((eq nwc/type 'bar)
            (if (nwc/in-tmux?)
                (if blink-cursor-mode
                    nwc/tmux-escape-code-blink-bar-cursor
                  nwc/tmux-escape-code-bar-cursor)
              (if blink-cursor-mode
                  nwc/escape-code-blink-bar-cursor
                nwc/escape-code-bar-cursor)))
           ((eq nwc/type 'hbar)
            (if (nwc/in-tmux?)
                (if blink-cursor-mode
                    nwc/tmux-escape-code-blink-hbar-cursor
                  nwc/tmux-escape-code-hbar-cursor)
              (if blink-cursor-mode
                  nwc/escape-code-blink-hbar-cursor
                nwc/escape-code-hbar-cursor)))
           (t "")))))

(defun nwc/turn-on ()
  "Enable changing cursor for no window"
  (interactive)
  (add-hook 'pre-command-hook 'nwc/set-cursor)
  (add-hook 'post-command-hook 'nwc/set-cursor))

(defun nwc/turn-off ()
  "Disable changing cursor for no window"
  (interactive)
  (remove-hook 'pre-command-hook 'nwc/set-cursor)
  (remove-hook 'post-command-hook 'nwc/set-cursor))

;;;###autoload
(define-minor-mode nwcursor-mode
  ""
  :lighter " █"
  :init-value nil
  :global t
  :group 'nwcursor
  (cond
   (noninteractive			; running a batch job
    (setq nwcursor-mode nil))
   (nwcursor-mode			; whitespace-mode on
    (nwc/turn-on))
   (t					; whitespace-mode off
    (nwc/turn-off))))

(provide 'nwcursor-core)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nwcursor-core.el ends here
