{ config, lib, pkgs, system, inputs, ... }:

{
  # Thông tin cơ bản
  home.username = "mike";
  # home.homeDirectory = "/Users/mike";  # Đường dẫn macOS

  # Các gói sẽ được cài đặt
  home.packages = with pkgs; [
    # Công cụ phát triển
  ];

  # Cấu hình Git
  programs.git = {
    enable = true;
    userName = lib.mkForce "architectureman";
    userEmail = lib.mkForce "vnknowledge2014@gmail.com";
    
    # Cấu hình bổ sung
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "code --wait";
    };
    
    # Bí danh
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
    };
  };

  # Cấu hình Zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "macos" "docker" "vscode" "npm" "yarn" ];
    };
    
    # Biến môi trường
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "code";
      LANG = "en_US.UTF-8";
      PATH = "$HOME/.local/bin:$PATH";
    };
    
    # Bí danh shell
    shellAliases = {
      ll = "eza -l --icons";
      la = "eza -la --icons";
      cat = "bat";
      top = "htop";
      g = "git";
    };
    
    # Cấu hình bổ sung
    initExtra = ''
      # Historry
      HISTSIZE=10000
      SAVEHIST=10000
      
      # Tích hợp FZF
      if [ -n "$(command -v fzf)" ]; then
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      fi
      
      # Greeting message
      echo "Welcome to your macOS development environment, Mike!"
      
      # Tích hợp với Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # Cấu hình Neovim
  # programs.neovim = {
  #   enable = true;
  #   viAlias = true;
  #   vimAlias = true;
    
  #   # Plugins Neovim
  #   plugins = with pkgs.vimPlugins; [
  #     vim-nix
  #     vim-commentary
  #     vim-surround
  #     vim-gitgutter
  #     vim-airline
  #     nord-vim
  #   ];
    
  #   # Cấu hình bổ sung
  #   extraConfig = ''
  #     set number
  #     set relativenumber
  #     set expandtab
  #     set tabstop=2
  #     set shiftwidth=2
  #     set autoindent
  #     set smartindent
  #     set cursorline
  #     set termguicolors
  #     colorscheme nord
  #   '';
  # };

  # Cấu hình VS Code
  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode;
    
  #   # Extensions
  #   extensions = with pkgs.vscode-extensions; [
  #     vscodevim.vim
  #     ms-python.python
  #     dbaeumer.vscode-eslint
  #     esbenp.prettier-vscode
  #     rust-lang.rust-analyzer
  #     redhat.vscode-yaml
  #     hashicorp.terraform
  #     ms-azuretools.vscode-docker
  #   ];
    
  #   # Cài đặt
  #   userSettings = {
  #     "editor.fontFamily" = "JetBrains Mono, Menlo, Monaco, 'Courier New', monospace";
  #     "editor.fontSize" = 14;
  #     "editor.fontWeight" = "normal";
  #     "editor.fontLigatures" = true;
  #     "editor.formatOnSave" = true;
  #     "editor.renderLineHighlight" = "all";
  #     "editor.rulers" = [ 80 120 ];
  #     "editor.minimap.enabled" = false;
  #     "workbench.colorTheme" = "Nord";
  #     "terminal.integrated.fontFamily" = "JetBrains Mono";
  #     "terminal.integrated.fontSize" = 14;
  #     "vim.useSystemClipboard" = true;
  #     "window.zoomLevel" = 0;
  #   };
  # };
  
  # Tmux
  # programs.tmux = {
  #   enable = true;
  #   keyMode = "vi";
  #   shortcut = "a";
  #   terminal = "screen-256color";
    
  #   # Cấu hình bổ sung
  #   extraConfig = ''
  #     # Đổi prefix sang Ctrl+a
  #     unbind C-b
  #     set -g prefix C-a
      
  #     # Mouse mode
  #     set -g mouse on
      
  #     # Split panes với | và -
  #     bind | split-window -h -c "#{pane_current_path}"
  #     bind - split-window -v -c "#{pane_current_path}"
      
  #     # Bắt đầu đánh số cửa sổ từ 1
  #     set -g base-index 1
  #     set -g pane-base-index 1
      
  #     # Làm mới status mỗi 5 giây
  #     set -g status-interval 5
      
  #     # Màu status bar
  #     set -g status-style bg=black,fg=white
      
  #     # Theme
  #     set -g status-left "#[fg=green]#S #[fg=yellow]#I #[fg=cyan]#P"
  #     set -g status-right "#[fg=cyan]%d %b %R"
  #   '';
  # };

  # Đảm bảo thư mục LaunchAgents có quyền truy cập đúng
  home.activation = {
    fixLaunchAgentsPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/Library/LaunchAgents"
      $DRY_RUN_CMD chmod $VERBOSE_ARG 755 "$HOME/Library/LaunchAgents"
    '';
  };
  
  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  
  # Bật Home Manager
  programs.home-manager.enable = true;
}