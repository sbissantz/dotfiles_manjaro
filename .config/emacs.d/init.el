;;
;; Stevens init file
;;
;; Hint: deleted all :ensure t
;; Speed up initialization
;; https://github.com/jwiegley/dot-emacs/blob/master/init.el

(defvar file-name-handler-alist-old file-name-handler-alist)
(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      auto-window-vscroll nil)

(add-hook 'after-init-hook
          `(lambda ()
             (setq file-name-handler-alist file-name-handler-alist-old
                   gc-cons-threshold 800000
                   gc-cons-percentage 0.1)
             (garbage-collect)) t)

;; Startup time 
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "%s with %d gc."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)

;; Configure package.el -- include MELPA and companions
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Use-package Ensure that use-package is installed.  
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (require 'use-package-ensure)
  (setq use-package-always-ensure t))

(use-package no-littering
  :defer nil)

(use-package gcmh
  :defer nil
  :custom (gcmh-verbose t)
  :config (gcmh-mode 1))

(add-to-list 'load-path "~/.emacs.d/lisp/")

(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (with-temp-buffer
    (write-file custom-file)))
(load custom-file)

;; (use-package bug-hunter)

(use-package auto-compile 
  :init (setq load-prefer-newer t)
  :config (auto-compile-on-load-mode))

(use-package benchmark-init
  :disabled ;; enable only when needed
  :demand ;; force loadng to occur
  ;; To disable collection of benchmark data after init is done.
  :hook (after-init . benchmark-init/deactivate))

(defun visit-emacs-config ()
  "Visit your configuration file"
  (interactive)
  (find-file "~/dotfiles/emacs.d/init.el"))

(defun reload-init-file ()
  "Reload your init file"
  (interactive)
  (load-file "~/dotfiles/emacs.d/init.el"))

(use-package evil-leader
  :init 
  (setq evil-want-keybinding nil)
  (global-evil-leader-mode)
  :config 
  (setq evil-leader/in-all-states t)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "bk" 'kill-this-buffer
    "br" 'evilmr-replace-in-buffer
    "cl" 'evilnc-comment-or-uncomment-lines
    "cd" 'comment-dwim			
    "cc" 'evilnc-copy-and-comment-lines
    "cp" 'evilnc-comment-or-uncomment-paragraphs
    "cr" 'comment-or-uncomment-region
    "ei" 'visit-emacs-config
    "er" 'reload-init-file
    "ff" 'helm-find-files
    "fs" 'helm-find ; searching dir's
    "fo" 'helm-occur ; search the file
    "fr" 'helm-recentf
    "ib" 'flyspell-buffer
    "im" 'flyspell-mode
    "ic" 'ispell-comments-and-strings
    "id" 'ispell-change-dictionary
    "ik" 'ispell-kill-ispell
    "im" 'ispell-message
    "ir" 'ispell-region
    "h" 'evil-window-left
    "H" 'evil-window-move-far-left
    "j" 'evil-window-down
    "J" 'evil-window-move-very-bottom
    "k" 'evil-window-up
    "K" 'evil-window-move-very-top
    "l" 'evil-window-right
    "L" 'evil-window-move-far-right
    "n" 'evil-window-next
    "N" 'evil-window-vnew
    "p" 'evil-window-prev
    "sh" 'evil-window-split
    "sv" 'evil-window-vsplit
    "wk" 'evil-window-delete
    "y" 'helm-show-kill-ring
    ">" 'evil-window-increase-width
    "<" 'evil-window-decrease-width
    "+" 'evil-window-increase-height
    "-" 'evil-window-decrease-height
    "."  'evilnc-copy-and-comment-operator
    ;; if you prefer backslash key
    "\\" 'evilnc-comment-operator)
  (evil-leader/set-key-for-mode
    'org-mode
    "t" 'org-set-tags-command
    "esc" 'org-edit-src-code
    "aem" 'anki-editor-mode
    "aein" 'anki-editor-insert-note
    "aepn" 'anki-editor-push-notes
    "aerf" 'anki-editor-retry-failure-notes
    "aecd" 'anki-editor-cloze-dwim
    "ms" 'org-mark-ring-push		
    "mm" 'org-mark-ring-goto)
  (evil-leader/set-key-for-mode
    'ess-mode
    "ese" 'org-edit-src-exit))

(use-package evil
  :after evil-leader
  :config (evil-mode 1)) 

(use-package evil-escape
  :after evil
  :config (progn
   	    (evil-escape-mode)
   	    (setq-default evil-escape-key-sequence "[escape]")))

(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :after evil) 

(use-package evil-mark-replace
  :after evil) 

(use-package evil-matchit
  :after evil
  :config (global-evil-matchit-mode 1))

(use-package evil-visualstar
  :after evil
  :config (global-evil-visualstar-mode 1))

(use-package evil-org
  :after evil
  :hook (org-mode . evil-org-mode))

(use-package evil-cleverparens
  :after evil
  :hook ((emacs-lisp-mode org-mode) . evil-cleverparens-mode))

;; (use-package helm
;;    :bind (("M-x" . helm-M-x)
;;  	 ("M-/" . helm-dabbrev))
;;   :config
;;   (helm-mode 1)
;;   ;; open helm buffer inside current window, not occupy other
;;   (setq helm-split-window-in-side-p t)
;;   ;; move to end or beginning of source when reaching top or bottom of source.
;;   (setq helm-move-to-line-cycle-in-source t)
;;   ;;enter search pattern in the header line
;;   (setq helm-echo-input-in-header-line t))

;; Update buffer
(use-package autorevert
  :config (global-auto-revert-mode 1))

(use-package aggressive-indent
  :defer 1
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package color-theme-sanityinc-tomorrow
  :config (load-theme 'sanityinc-tomorrow-eighties t))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode ess-mode) . rainbow-delimiters-mode))

;; rainbow-delimiters-unmatched-face

(use-package moody
  :config (progn
	    (setq x-underline-at-descent-line t)
	    (moody-replace-mode-line-buffer-identification)
	    (moody-replace-vc-mode)))

(use-package minions
  :config (progn
	    (setq minions-mode-line-lighter "")
	    (setq minions-mode-line-delimiters '("" . ""))
	    (minions-mode 1)))

(progn ; `startup'
  (setq inhibit-startup-screen t)
  (setq initial-buffer-choice t)
  (setq initial-major-mode 'text-mode)
  (setq initial-scratch-message nil))

(progn `user'
       (setq user-full-name "Steven, Marcel Bißantz")
       (setq calendar-latitude 49.197204)
       (setq calendar-longitude 8.114866)
       (setq calendar-location-name "Landau, RP"))

(progn ; `lines'
  (global-hl-line-mode 1)
  (setq line-move-visual nil)
  (global-visual-line-mode 1)
  (global-display-line-numbers-mode 1))

(progn ; `cursor'
  (global-subword-mode 1)
  (blink-cursor-mode 0))
;;(modify-all-frames-parameters (list (cons 'cursor-type 'bar)))

(progn ; `minibuffer'
  (savehist-mode 1))
;; (setq max-mini-window-height 0.5)

(progn ; `hide-bars'
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(progn ; `files'
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq create-lockfiles nil)
  (setq backup-by-copying t))

(progn ; `map-ynp'
  (setq read-answer-short t)
  (fset 'yes-or-no-p 'y-or-n-p))

(progn ; `exit'
  (setq confirm-kill-emacs 'y-or-n-p))

(defun kill-this-buffer ()
  "Approved kill current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(progn ;`foundlings')
  (global-set-key (kbd "M-SPC") 'cycle-spacing))

(use-package auto-fill-mode
  :ensure nil
  :hook ((text-mode org-mode) . auto-fill-mode))

(use-package org
  :defer t
  :ensure org-plus-contrib
  :init
  (setq org-agenda-inhibit-startup t
	org-agenda-use-tag-inheritance nil)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((R . t)
     (latex . t)))
  (setq org-confirm-babel-evaluate nil)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("r" . "src R"))
  (setq org-latex-create-formula-image-program 'dvipng)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width 400)
  (setq org-startup-indented t)
  (setq org-src-window-setup 'current-window)
  (setq org-refile-use-outline-path t)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-todo-keywords
	'((sequence "TODO" "IN-PROGRESS" "QUEUED" "DONE")))
  (setq org-ellipsis " ")
  :bind (("C-c l" . org-store-link)
	 ("C-c c" . org-capture)
	 ("C-c a" . org-agenda)
	 ("C-c b" . org-switchb)))

(use-package org-download
  :after org)

(use-package org-ref ; apalike-german
  :after org 
  :init (setq org-ref-default-bibliography '("~/library/bibliography/references.bib")
	      org-ref-default-citation-link "citep" 
	      org-ref-bibliography-notes "~/library/bibliography/notes.org"
	      org-ref-pdf-directory "~/library/bibliography/bibtex_pdf/")
  :config (setq bibtex-autokey-year-length 4
		bibtex-autokey-name-year-separator "-"
		bibtex-autokey-year-title-separator "-"
		bibtex-autokey-titleword-separator "-"
		bibtex-autokey-titlewords 2
		bibtex-autokey-titlewords-stretch 1
		bibtex-autokey-titleword-length 5))

(use-package ox-beamer
  :ensure nil
  :after org)

;; https://orgmode.org/manual/Export-Settings.html
(use-package ox-latex
  :ensure nil
  :after org
  :config
  (setq org-export-default-language "de")
  (setq org-latex-logfiles-extensions
        (quote
         ("lof" "lot" "tex" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" 
          "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "pygtex" "pygstyle")))
  (add-to-list 'org-latex-classes
	       '("smb"
		 "\\documentclass[twocolumn,twoside]{article}
                    % Fontencoding
                    \\usepackage[T1]{fontenc} %0T1 fontenc
                    \\usepackage[utf8]{inputenc} %expand: UTF8's
                    % Fonts
                    \\usepackage{kpfonts} %load: amsmath,textcomp by default
                    % Languages
                    \\usepackage[ngerman,english]{babel} 
                    % Enumerations 
                    \\usepackage{enumitem} %Consider: nosep
                    \\setlist{noitemsep} %Dont space items (Req: enumitem)
                    % Citations
                    \\usepackage[natbibapa]{apacite}
                    % Graphics
                    \\usepackage{psfrag,graphicx} %use them together
                    % (Micro-)Typography
                    \\usepackage{microtype}
                    \\usepackage{xspace} 
                    \\newcommand{\\zB}{\\mbox{z.\\,B.}\\xspace}
                    \\newcommand{\\dH}{\\mbox{d.\\,h.}\\xspace}
                    % Paragraphs
                    \\usepackage{parskip}
                    \\setlength{\\parindent}{0em} %Dont indent par's
                    \\setlength{\\parskip}{1ex} %Space par's horizontally
                    % Abstract
                    \\usepackage{abstract}
                    \\renewcommand{\\abstractnamefont}{\\normalfont\\bfseries}
                    \\renewcommand{\\abstracttextfont}{\\normalfont\\small\\itshape}
                    % Headings 
                    \\usepackage{titlesec}
                    \\renewcommand\\thesection{\\Roman{section}} 
                    \\renewcommand\\thesubsection{\\roman{subsection}}
                    \\titleformat{\\section}[block]{\\large\\scshape\\centering}{\\thesection.}{1em}{}
                    % Tile, Author...
                    \\usepackage{titling}
                    \\setlength{\\droptitle}{-4\\baselineskip}
                    \\pretitle{\\begin{center}\\Huge\\bfseries}
                    \\posttitle{\\end{center}}
                    % Links (for convenience)
                    \\usepackage{hyperref}
                    \\hypersetup{hidelinks}
                    [NO-DEFAULT-PACKAGES]
                    [NO-PACKAGES]
                    [NO-EXTRA]"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")))
  (setq org-export-with-toc 'nil)	; sets table of contents 'nil
  (defun org-export-latex-no-toc (depth)
    (when depth
      (format "%% Org-mode is exporting headings to %s levels.\n"
	      depth)))
  (setq org-export-latex-format-toc-function 'org-export-latex-no-toc)
  (unless (boundp 'org-latex-classes)
    (setq org-latex-classes nil))
  (setq org-latex-pdf-process
	'("pdflatex -interaction nonstopmode -output-directory %o %f"
	  "bibtex %b"
	  "pdflatex -interaction nonstopmode -output-directory %o %f"
	  "pdflatex -interaction nonstopmode -output-directory %o %f"))
  (setq bibtex-dialect 'biblatex)
  (setq org-export-with-smart-quotes t)
  (setq user-full-name "Steven Marcel Bißantz"))
;; (setq org-export-with-email 't)
;; (setq user-mail-address "steven.bissantz@gmail.com"))

;; (setq org-latex-compiler "lualatex")
;; '("lualatex -shell-escape -interaction nonstopmode %f"
;;   "bibtex %b"
;;   "lualatex -shell-escape -interaction nonstopmode %f"
;;   "lualatex -shell-escape -interaction nonstopmode %f"))

;; (setq org-latex-compiler "xelatex")
;; ;; load babel with appropriate language as argument
;; (add-to-list 'org-latex-packages-alist
;; 	       '("AUTO" "polyglossia" t ("xelatex")))
;; ;; (add-to-list 'org-preview-latex-process-alist
;; ;; 	       '("" "dvisvgm"))
;; ;; set default export language -- locally with '#+language: en'
;; ;;export quotes according to language 
;; (setq org-export-with-smart-quotes t) 
;; (setq org-latex-prefer-user-labels t)
;; (setq org-latex-caption-above nil)
;; ;;(setq-default TeX-PDF-mode t)
;; (setq org-latex-pdf-process
;; 	'("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;; 	  "bibtex %b"
;; 	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;; 	  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
;; ;; ban akward files-extensions
;; (setq org-export-latex-default-packages-alist
;; 	'(("AUTO" "inputenc" nil)
;; 	  ("T1"   "fontenc"   nil)
;; 	  (""     "latexsym"  nil)
;; 	  (""     "breakcites" nil)
;; 	  (""     "amssymb"   t))))

(use-package ox-reveal
  :after org
  :config (setq org-reveal-note-key-char nil
		;; org-reveal-ignore-speaker-notes t
		org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

(use-package cdlatex
  :after org
  :hook (org-mode . turn-on-org-cdlatex))

(use-package htmlize
  :after ox-reveal)

(use-package magit
  :bind ("C-x g" . magit-status)
  :hook (with-editor-mode . evil-insert-state)
  :config (progn
	    (use-package evil-magit)
	    (use-package with-editor)
	    (setq magit-push-always-verify nil)
	    (setq git-commit-summary-max-length 50)))

(use-package ess
  :ensure nil 
  :defer 2)

(use-package ispell
  :no-require t
  :defer t)

(use-package flyspell
  :defer t
  :config (setq flyspell-issue-message-flag nil))

(use-package anki-editor
  :defer t)

;; (use-package spss
;;   :load-path ("lisp/spss.el"))
