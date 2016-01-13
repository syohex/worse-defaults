;;; worse-defaults --- Because Emacs defaults are better.. Not.

;;; Copyright (C) 2016 David Chkhikvadze

;;; Author: David Chkhikvadze <david.chk@outlook.com>
;;; Maintainer: David Chkhikvadze <david.chk@outlook.com>
;;; Version: 0.0.1
;;; Created: 13th January 2016
;;; Keywords: defaults

;;; This file is NOT part of GNU Emacs.

;;; License:

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to the
;;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,

;;; Commentary:

;;; Things in this package represent better (worse?) default settings
;;; for many things that Emacs ships with.

;;; This defaults are also somewhat opinionated, which might not be
;;; acceptable for everyone, hence `worse`.

;;; There is a package in MELPA called better-defaults which
;;; intentionally tries to be minimal. If you disagree with these
;;; defaults, you should consider that one instead.

;;; Code:

;;; Which system are we running on?
(defvar is-mac (equal system-type 'darwin)
  "T when Emacs is running on Mac.")

(defvar is-windows (equal system-type 'windows-nt)
  "T when Emacs is running on Windows.")

(defvar is-cygwin (equal system-type 'cygwin)
  "T when Emacs is running on Cygwin.")

(defvar is-linux (equal system-type 'gnu/linux)
  "T when Emacs is running on Linux.")

;;; If the elc is older than el, load el, avoid loading stale code.
(setq load-prefer-newer t)

;;; Provide pure Emacs experience by default. Leave menu-bar on if
;;; running on Mac and in GUI mode, disable it for every other case.
(unless (and is-mac window-system)
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;;; Set Emacs home directory explicitly to avoid any confusion.
;;; Aquamacs for example has strange defaults..
(setq user-emacs-directory (expand-file-name "~/.emacs.d/"))

;;; Do not display a help screen on startup.
(setq inhibit-splash-screen t)

;;; Do not display startup help message in the minibuffer. Use the
;;; standard key binding for help `F1` instead.
(setq inhibit-startup-message t)
(defun display-startup-echo-area-message nil nil)

(global-set-key (kbd "<f1>") 'help-command)

;;; Do not display startup message in the *scratch* buffer.
(setq initial-scratch-message nil)

;; Do not make annoying sounds, provide visual feedback instead.
(setq visible-bell t)

;;; Unless running in terminal, disable visual feedback as well.
(when window-system
  (setq ring-bell-function 'ignore))

;;; Do not blink the cursor.
(blink-cursor-mode 0)

;;; Do not use block cursor on graphic displays.
(if window-system
    (setq-default cursor-type '(bar . 1))
    (setq-default cursor-type '(bar . 2)))

;;; Do not display GUI dialogs, and simplify the answering.
(setq use-dialog-box nil)
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Show empty lines like Vim does.
(setq-default indicate-empty-lines t)

;;; Provide maximum syntax highlighting by default.
(setq font-lock-maximum-decoration t)
(global-font-lock-mode 1)

;;; Ensure that buffer names are displayed uniquely to avoid any
;;; confusion.
(require 'uniquify)
(setq uniquify-buffer-name-sty-le 'forward)

;;; Show the popup buffers underneath the current one, this makes it
;;; more predictable, hence less annoying.
(setq split-height-threshold nil
      split-width-threshold 9999)

;;; Show full path to the current file in the title.
(setq frame-title-format
      (list (format "%%j ")
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;;; Enable all commands which are disabled by default. I am so scared!
(setq disabled-command-function nil)

;;; Automatically update the buffer if file changes on disk, and try
;;; to be quiet about it.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      auto-revert-check-vc-info t)

;;; Edit compressed files by uncompressing and compressing files on
;;; the fly.
(auto-compression-mode 1)

;;; Increase GC treshold to 50MiB because it is 21st century.
(setq gc-cons-threshold 50000000)

;;; Use UTF-8 for defaults!
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; Highlight matching parenthesis. The following must be set before
;;; activating the mode to make it work.
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

;;; File system shall not be polluted! backup files will be stored in
;;; ~/.emacs.d/backups.
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups"))))
      backup-by-copying t
      delete-old-versions t
      keep-new-version 6
      kept-old-versions 2
      version-control t
      tramp-backup-directory-alist backup-directory-alist)

;;; File system shall not be polluted! autosave files go to tmp.
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; File system shall not be polluted! no lock files!
(setq create-lockfiles nil)

;;; Ensure that history of typed commands is saved. Ensure that search
;;; strings are saved. Store the relevant file under ~/.emacs.d. do this
;;; automatically every 60 seconds.
(setq savehist-additional-variables
      '(search ring regexp-search-ring)
      savehist-autosave-interval 60
      savehist-file (expand-file-name ".savehist"
                                      user-emacs-directory))

(savehist-mode 1)

;;; Do not store duplicates of typed commands Increase the number of
;;; saved items.
(setq history-length 1000
      history-delete-duplicates t)

;;; Save position of point between sessions and store history file under
;;; ~/.emacs.d.
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places"
                                        user-emacs-directory))

;;; Save a list of recently visited files, open the list using `C-x f`.
(require 'recentf)
(setq recentf-max-saved-items 100)
(global-set-key (kbd "C-x f") 'recentf-open-files)

;;; Make sure recentf does not display obviously useless stuff in ~/.emacs.d.
(setq recentf-exclude
      '("~/.emacs.d/elpa/"
        "\\.last\\'"))

(recentf-mode 1)

;;; Keep bookmarks file under ~/.emacs.d.
(setq bookmark-default-file (expand-file-name "bookmarks" user-emacs-directory))

;;; Each command that sets a bookmark will also save bookmarks.
(setq bookmark-save-flag 1)

;;; Treat selection "normally" overwrite and delete selected text like
;;; other editors.
(delete-selection-mode 1)
(transient-mark-mode 1)
(make-variable-buffer-local 'transient-mark-mode)
(put 'transient-mark-mode 'permanent-local t)
(setq-default transient-mark-mode t)

;;; Insert where the point is when pasting.
(setq mouse-yank-at-point t)

;;; Include noninteractive functions in the search too.
(setq apropos-do-all t)

;;; Show line and column numbers in the mode line. This is better than
;;; scroll bar!
(setq line-number-mode 1)
(column-number-mode 1)

;;; Display the size of the buffer in the position display.
(setq size-indication-mode t)

;;; Do not use tabs! Use 2 spaces instead, because compact code is
;;; nice and it is a pretty common default setting.
(set-default 'indent-tabs-mode nil)
(setq-default tab-width 2)

;;; No sentence ends in a double space!
(set-default 'sentence-end-double-space nil)

;;; Make sure to add a final newline when saving
;;; if there isn't one already.
(setq require-final-newline t
      mode-require-final-newline t)

;;; Delete files by moving them to Trash when possible.
(setq  delete-by-moving-to-trash t)

;;; Do not save duplicates in kill ring.
(setq kill-do-not-save-duplicates t)

;;; Support the desktop environment clipboard.
(setq x-select-enable-clipboard t
      x-select-request-type
      '(UTF8_STRING COMPOUND_TEXT TEXT STRING)
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      x-select-enable-clipboard t)

;;; Self explanatory, can be *really annoying* sometimes..
(setq save-interprogram-paste-before-kill t)

;;; Keep filename in the log entries.
(setq log-edit-strip-single-file-name nil)

;;; Use UTC for log file time stamps.
(setq add-log-time-zone-rule t)

;;; File-local variables can be dangerous. There is no telling what
;;; local variables list from third-party file could do to your Emacs.
;;; This option enables loadig of safe ones everything else will issue
;;; a prompt.
(setq enable-local-variables :safe)

;;; Handle kill commands in read-only buffers specially they do not
;;; delete text of course, *read-only* doh, instead it will copy and
;;; move over.
(setq kill-read-only-ok t)

;;; Use regex versions of search commands by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)

;;; Do not wrap lines, use visual-line-mode when you need it. Use
;;; indicators for lines wrapped with visual-line-mode.
(setq truncate-partial-width-windows nil)
(setq-default truncate-lines t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;;; Use zap-up-to-char instead of zap-to-char.
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR." t)

;;; Highlight current line
(when window-system
  (global-hl-line-mode 1))

;;; Display useful information in the echo area when point is on
;;; function names, variable names et. al.
(require 'eldoc)

(setq eldoc-idle-delay 0.2)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

(defun goto-matching-paren (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg))
        ((looking-back "\\s)" 1) (backward-sexp arg))
        ;; Now, try to succeed from inside of a bracket
        ((looking-at "\\s)") (forward-char) (backward-sexp arg))
        ((looking-back "\\s(" 1) (backward-char) (forward-sexp arg))))

(global-set-key (kbd "C-c {") 'goto-matching-paren)

;;; Recursive editing deserves a key binding.
(global-set-key (kbd "C-x re") 'recursive-edit)

;; Allow recursive minibuffers.
(setq enable-recursive-minibuffers t)

;;; Fix scrolling, it is pretty much broken when using a mouse, but
;;; still, this takes it from being impossible to use to just
;;; horrible.. On Mac OS X using the port by Yamamoto Mitsuharu fixes
;;; this, but users of stock Emacs beware.
(setq scroll-step 1
      scroll-conservatively 10000
      auto-window-vscroll nil
      mouse-wheel-progressive-speed nil)

;;; Make sure the dired buffer is refreshed each time there is a change.
(dolist (cmd '(dired-do-rename
               dired-do-copy
               dired-create-directory
               wdired-abort-changes))
  (advice-add cmd :after #'revert-buffer))

;;; Make dired delete files with k like Magit.
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "k") 'dired-do-delete))

;; Show keystrokes in progress.
(setq echo-keystrokes 0.1)

;; Undo/redo window configuration with C-c <left>/<right>.
(winner-mode 1)

;;; Enable printing of deeply nested lists.
(setq eval-expression-print-level nil)

;;; Preserve the location of point for every window, instead of every buffer.
(setq switch-to-buffer-preserve-window-point t)

;;; Replace dabbrev-expand with hippie-expand because the later
;;; includes the results from former, but also more.
(global-set-key (kbd "M-/") 'hippie-expand)

;;; Ediff will not use a new frame.
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; Ido mode or ibuffer configuration is not included on purpose,
;;; because you should use Helm, you really should!

;;;###autoload
(when load-file-name
  (add-to-list
   'load-path
   (file-name-as-directory (file-name-directory load-file-name))))

(provide 'worse-defaults)

;;; worse-defaults.el ends here
