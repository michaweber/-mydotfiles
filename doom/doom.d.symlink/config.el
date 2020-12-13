;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Michael Weber"
      user-mail-address "michael")

;; doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

(setq projectile-project-search-path '("~/Code/src/github.com/michaweber"))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;
;; You need to wrap your configuration in (after! X ...) blocks,
;; where X is the name of the package you want to configure.
;; In this case (after! org ...). Without this, your settings are evaluated
;; too early (immediately), which are likely to be overwritten by Doom's own
;; defaults. after! ensures the code runs after the package
;; (and doom's defaults) are loaded.
;;
;; The only exception are file and directory variables,
;; like org-directory or org-attach-id-dir.

(setq org-directory "~/files/org/")

(setq org-jira-working-dir "~/files/org/jira")

(after! org
  (setq org-agenda-files (list "~/files/org/life.org"
                               "~/files/org/inbox.org"
                               "~/files/org/jira"
                               "~/files/org/essensplan.org"
                               "~/files/org/tickler.org")))

(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t!)"
                    "NEXT(n!)"
                    "WAITING(w!)"
                    "NEEDS FEEDBACK(f!)"
                    "BLOCKED(b!)" "PROJ(p!)"
                    "FOLLOWUP(f!)"
                    "|"
                    "CANCELLED(c!)"
                    "DONE(d!)"
                    "PHONE(P!)"))))

(after! org (setq org-todo-keyword-faces
      '(("PROJ" :foreground "light blue" :weight bold)
              ("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

;; org-refile
(setq org-refile-targets (quote ((nil :maxlevel . 10)
                                   (org-agenda-files :maxlevel . 10))))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; org-roam
(setq org-roam-directory "~/files/org/org-roam")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Use cmd as meta instead of alt, otherwise we can't use alt+l for @, oder
;; alt+n for ~ on german keyboard
(setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

;; golang

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; (use-package! org-download
;;   :after org
;;   :config
;;   (setq-default org-download-image-dir "./org-images/"
;;                 org-download-delete-image-after-download t
;;                 org-download-method 'directory
;;                 org-download-heading-lvl 1
;;                 ))


(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
  ; take screenshot
  (if (eq system-type 'darwin)
      (call-process "screencapture" nil nil nil "-i" filename))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
  ; insert into file if correctly taken
  (if (file-exists-p filename)
    (insert (concat "[[file:" filename "]]"))))

(defun org-insert-clipboard-image (&optional file)
  (interactive "F")
  (shell-command (concat "pngpaste " file))
  (insert (concat "[[" file "]]"))
  (org-display-inline-images))
