;;; doom-hr.el --- HR tools for D.E. Incorporated -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Colin Woodbury
;;
;; Author: Colin Woodbury <colin@fosskers.ca>
;; Maintainer: Colin Woodbury <colin@fosskers.ca>
;; Created: March 14, 2022
;; Modified: March 14, 2022
;; Version: 0.1.0
;; Keywords: tools
;; Homepage: https://github.com/fosskers/doom-hr
;; Package-Requires: ((emacs "27.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; HR tools for Doom Emacs Incorporated.
;;
;; Totally serious and definitely not a joke package.
;;
;;; Code:

(require 'cl-lib)
(require 'calc-comb)

(defun doom-hr--days-since-epoch ()
  "The number of days passed since the Unix epoch."
  (/ (time-convert nil 'integer) 86400))

(defun doom-hr--prime-p (num)
  "Determine if the given NUM is prime."
  (cl-case (calcFunc-prime num)
    (1 t)))

(defun doom-hr--next-prime (num)
  "Find the next prime number after NUM."
  (let ((next (1+ num)))
    (cond ((doom-hr--prime-p next) next)
          (t (doom-hr--next-prime next)))))

(defun doom-hr--date-string (day)
  "Convert a numeric DAY to a human-readable date string."
  (let* ((seconds (* 86400 day))
         (time (decode-time seconds)))
    (format "%d-%02d-%02d"
            (decoded-time-year time)
            (decoded-time-month time)
            (decoded-time-day time))))

(defun doom-hr--system-on (day)
  "Calculate which system must be used on the given DAY."
  (cond ((cl-evenp day) 'guix)
        ((doom-hr--prime-p day) 'windows)
        (t 'nix)))

(defun doom-hr-today ()
  "Yield the company-mandated system to use for today."
  (interactive)
  (message "%s" (doom-hr--system-on (doom-hr--days-since-epoch))))

(defun doom-hr-next-windows-day ()
  "Determine the nearest date when Windows will be mandatory."
  (interactive)
  (thread-last
    (doom-hr--days-since-epoch)
    (doom-hr--next-prime)
    (doom-hr--date-string)
    (message "%s")))

(provide 'doom-hr)
;;; doom-hr.el ends here
