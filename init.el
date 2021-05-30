;; .emacs

;; Enable org-mode
(require 'org)

;; ===================================
;; MELPA Package Support
;; ===================================
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; enable auto-complete in c++ (or other languages)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet-snippets)
(yas-global-mode 1)


;;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(default ((t (:family "JetBrainsMono Nerd Font" :foundry "JB  " :slant normal :weight normal :height 121 :width normal)))))

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    elpy                            ;; Emacs Lisp Python Environment
    flycheck                        ;; On the fly syntax checking
;;    ein                             ;; Emacs IPython Notebook
    material-theme                  ;; Theme
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ===================================
;; Basic Customization
;; ===================================
(setq make-backup-files nil)        ;; Prevent backup of name.ext (name.ext~)
(setq inhibit-startup-message t)    ;; Hide the startup message
(setq visible-bell 1)               ;; Disables system sound (beep) 
(setq scroll-step 1)                ;; Smooth keyboard scrolling
(load-theme 'material t)            ;; Load material theme
(global-linum-mode t)               ;; Enable line numbers globally
;;(setq org-pretty-entities t)        ;; Get LaTeX font rendering
(setq-default tab-width 4)          ;; Tab width set
(setq-default tab-stop-list 4)      ;; Tab stop width
(setq indent-tabs-mode nil)         ;; Disable indent using tabs
(set-frame-font  "Fira Code 12" nil t) ;; Set global emacs font
(setq-default fill-column 80)       ;; Change width to 80
(global-set-key (kbd "C-x C-]") 'comment-line)
;;(setq org-link-file-path-type adaptive)     ;; link files can be relative
;; or absolute
(setq org-export-with-sub-superscripts nil) ;; export without subscripts
;; Enabling markdown highlighting
;;(face-attribute 'bold :weight)
;;(face-attribute 'italic :slant)
;;(set-face-attribute :weight 'bold :slant 'italic)

;;-----------------------------------
;; Markdown - mode configuration here
;;-----------------------------------

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;-----------------------------------
;;-----------------------------------

;; hugo config here
(defun cesco/easy-hugo ()
  (interactive)
  (evil-define-key
    (list 'normal 'insert 'visual 'motion)
    easy-hugo-mode-map
    "n" 'easy-hugo-newpost
    "D" 'easy-hugo-article
    "p" 'easy-hugo-preview
    "P" 'easy-hugo-publish
    "o" 'easy-hugo-open
    "d" 'easy-hugo-delete
    "e" 'easy-hugo-open
    "c" 'easy-hugo-open-config
    "f" 'easy-hugo-open
    "N" 'easy-hugo-no-help
    "v" 'easy-hugo-view
    "r" 'easy-hugo-refresh
    "g" 'easy-hugo-refresh
    "s" 'easy-hugo-sort-time
    "S" 'easy-hugo-sort-char
    "G" 'easy-hugo-github-deploy
    "A" 'easy-hugo-amazon-s3-deploy
    "C" 'easy-hugo-google-cloud-storage-deploy
    "q" 'evil-delete-buffer
    (kbd "TAB") 'easy-hugo-open
    (kbd "RET") 'easy-hugo-preview)
  (define-key global-map (kbd "C-c C-e") 'easy/hugo))

(setq easy-hugo-basedir "~/hugo-helionotes/")
(setq easy-hugo-postdir "content/post")
(setq easy-hugo-url "http://localhost:1313/")
(setq easy-hugo-previewtime "20")
(setq easy-hugo-markdown-extension "md")
(define-key global-map (kbd "C-c C-e") 'easy-hugo)
;; hugo config ends here

(setq org-emphasis-alist
  '(("*" (bold :foreground "Orange" ))
    ("/" (italic :foreground "green" ))
    ("_" (:underline t))
    ("=" (:background "maroon" :foreground "white"))
    ("~" (:background "deep sky blue" :foreground "MidnightBlue"))
    ("+" (:strike-through t))))
;; ====================================
;; Development Setup
;; ====================================

;; Enable elpy
(elpy-enable)

;; Use IPython for REPL
(setq python-shell-interpreter "jupyter"
;;(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
            "jupyter")
;;             "ipython")

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(setq flycheck-check-syntax-automatically '(save mode-enable))

;;****************************************************************
;; User-Defined .emacs ends here
;;****************************************************************
;; (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(setq auto-mode-alist (cons '("\\.ipp$"  . c++-mode) auto-mode-alist))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vimish-fold cuda-mode yasnippet-snippets auto-complete popup-edit-menu markdown-mode ox-hugo easy-hugo material-theme magit-popup htmlize gnu-elpa-keyring-update flycheck evil elpy better-defaults async))
 '(xterm-mouse-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
