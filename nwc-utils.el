;;; nwc-utils.el --- No window cursor utils.
;; 
;; Filename: nwc-utils.el
;; Description: 
;; Author: 7696122
;; Maintainer: 7696122
;; Created: Sun Nov  6 03:39:15 2016 (+0900)
;; Version: 
;; Package-Requires: ()
;; Last-Updated: 
;;           By: 
;;     Update #: 0
;; URL: 
;; Doc URL: 
;; Keywords: 
;; Compatibility: 
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

(defun nwc/in-dumb? ()
  "Running in dumb."
  (string= (getenv "TERM") "dumb"))

(defun nwc/in-iterm? ()
  "Running in iTerm."
  (string= (getenv "TERM_PROGRAM") "iTerm.app"))

(defun nwc/in-xterm? ()
  "Runing in xterm."
  (getenv "XTERM_VERSION"))

(defun nwc/in-gnome-terminal? ()
  "Running in gnome-terminal."
  (string= (getenv "COLORTERM") "gnome-terminal"))

(defun nwc/in-konsole? ()
  "Running in konsole."
  (getenv "KONSOLE_PROFILE_NAME"))

(defun nwc/in-apple-terminal? ()
  "Running in Apple Terminal"
  (string= (getenv "TERM_PROGRAM") "Apple_Terminal"))

(defun nwc/in-tmux? ()
  "Running in tmux."
  (getenv "TMUX"))

(defun nwc/get-current-gnome-profile-name ()
  "Return Current profile name of Gnome Terminal."
  ;; https://github.com/helino/current-gnome-terminal-profile/blob/master/current-gnome-terminal-profile.sh
  (if (nwc/in-gnome-terminal?)
      (let ((cmd "#!/bin/sh
FNAME=$HOME/.current_gnome_profile
gnome-terminal --save-config=$FNAME
ENTRY=`grep ProfileID < $FNAME`
rm $FNAME
TERM_PROFILE=${ENTRY#*=}
echo -n $TERM_PROFILE"))
        (shell-command-to-string cmd))
    "Default"))

(defun nwc/color-name-to-hex (color)
  "Convert color name to hex value."
  (apply 'color-rgb-to-hex (color-name-to-rgb color)))

(provide 'nwc-utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; nwc-utils.el ends here
