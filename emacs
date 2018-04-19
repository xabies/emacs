;; Configure Repositories
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Load theme Theme
(load-theme 'darkokai t)

;; Replace selection
(delete-selection-mode 1)

;; Dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-items '(
			(projects . 5)
			(bookmarks . 5)
			(recents  . 5)
                        ))


;; Neotre F8 key
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)


;; Flyspell
(global-set-key [f6] 'flyspell-prog-mode)

;; make buffer switch command auto suggestions, also for find-file command
;;(ido-mode 1)
;; Helm
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

;; (setq helm-projectile-fuzzy-match nil)
(projectile-mode)
(require 'helm-projectile)
(helm-projectile-on)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

;; AutoPair: Autoclose bracktes etc.
(require 'autopair)
(autopair-global-mode 1)

;; Yasnipet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)


;; Git Gutter
(global-git-gutter+-mode)


;; Org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda-list)
(setq org-agenda-window-setup 'current-window) 
(setq org-log-done t)

(setq org-agenda-files (list "~/org/agenda.org"))


;; C/C++ IDE

(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

(setq c-default-style "linux"
          c-basic-offset 4)

;; Source code navigation using RTags
(require 'rtags)
(require 'company-rtags)

(setq rtags-completions-enabled t)
(eval-after-load 'company
  '(add-to-list
    'company-backends 'company-rtags))
(setq rtags-autostart-diagnostics t)
(rtags-enable-standard-keybindings)

;; Enable helm integration
;;(require 'rtags-helm)
;;(require 'setup-helm-rtags)
(setq rtags-use-helm t)

;; Before using RTags you need to start rdm and index your project. In
;; order to index your project, RTags requires you to export your
;; project's compile commands with cmake. Install rtags!!!

;; $ rdm &
;; $ cd /path/to/project/root
;; $ cmake . -DCMAKE_EXPORT_COMPILE_COMMANDS=1
;; $ rc -J .

;; Source code completion using Irony
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; NOTE: Like RTags, Irony requires a compilation database. To create one run the following:
;; $ cd /path/to/project/root
;; $ cmake . -DCMAKE_EXPORT_COMPILE_COMMANDS=1

;; The first time you run irony you must install the irony-server by runing the command: M-x irony-install-server

;; Using Company with Irony
;; Install company-irony from melpa
(global-company-mode)

(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(setq company-backends (delete 'company-semantic company-backends))
;;(eval-after-load 'company
;;  '(add-to-list
;;    'company-backends 'company-irony))

;; enable tab-completion with no delay use the following:
(setq company-idle-delay 0)
(define-key c-mode-map [(C-tab)] 'company-complete)
(define-key c++-mode-map [(C-tab)] 'company-complete)

;; Header file completion with company-irony-c-headers
;; Install company-irony-c-headers from MELPA 



;; Syntax checking with Flycheck
;; Install flycheck from MELPA
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)


;; Integrating RTags with Flycheck
(require 'flycheck-rtags)

(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
;; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;; Integrating Irony with Flycheck
;; Install flycheck-irony from MELPA
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(require 'company-irony-c-headers)
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

;; CMake automation with cmake-ide
;; Install cmake-ide from MELPA
(require 'subr-x)
(require 'cl-lib)
(require 'cl)
(require 'rtags)
(cmake-ide-setup)
;; To have cmake-ide automatically create a compilation commands file
;; in your project root create a .dir-locals.el containing the
;; following:
;; ((nil . ((cmake-ide-build-dir . "<PATH_TO_PROJECT_BUILD_DIRECTORY>"))))

;; You can now build your project using M-x
;; cmake-ide-compile. Additionally, cmake-ide will automatically
;; update your RTags index as well.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "6ee6f99dc6219b65f67e04149c79ea316ca4bcd769a9e904030d38908fd7ccf9" default)))
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/usr/include/qt4/" "-I/home/<user>/project_root/include2/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


; Python
(package-initialize)
(elpy-enable)

