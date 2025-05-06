(setq make-backup-files nil)
;;; init.el --- Emacs 配置文件 -*- lexical-binding: t; -*-

;;; Commentary:
;; 这是我的 Emacs 配置，适用于 macOS 下的终端（如 iTerm2）使用。
;; 配置了 C++ 开发环境：LSP（clangd）、company 自动补全、flycheck 语法检查等。
;; 同时使用清华镜像源加速插件下载，避免 GitHub 网络问题。
;; 提供了稳定快捷键（如 C-c a）用于 clangd 自动修复，无需依赖 GUI 特性。

;;; Code:

;; 初始化包系统，使用清华镜像
(require 'package)
(setq package-archives
      '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;; 安装 use-package（如未安装）
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; which-key：显示快捷键提示
(use-package which-key
  :config (which-key-mode))

;; company：自动补全
(use-package company
  :hook (after-init . global-company-mode))

;; flycheck：语法检查
(use-package flycheck
  :init (global-flycheck-mode))

;; lsp-mode：C++ LSP 支持
(use-package lsp-mode
  :hook ((c++-mode . lsp)
         (c-mode . lsp))
  :commands lsp
  :config
  ;; 设置 Homebrew 安装的 clangd 路径（17版）
  (setq lsp-clients-clangd-executable "/opt/homebrew/opt/llvm@17/bin/clangd"))

;; 绑定快捷键：在终端中调用 LSP 自动修复
(global-set-key (kbd "C-c a") 'lsp-execute-code-action)

;; projectile：项目导航
(use-package projectile
  :init (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

;; 切换头文件/源文件
(global-set-key (kbd "C-c o") 'ff-find-other-file)

;; 终端兼容优化（GUI-only 设置仅在图形界面生效）
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; 关闭启动画面
(setq inhibit-startup-screen t)

(provide 'init)
;;; init.el ends here
