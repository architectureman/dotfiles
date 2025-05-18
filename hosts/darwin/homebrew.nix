{ config, lib, pkgs, ... }:

{
  # Cấu hình Homebrew cơ bản
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    
    # Quản lý Brewfile
    global = {
      brewfile = true;
    };
    
    # Các package cơ bản cho tất cả máy
    brews = [
      "mas" # Mac App Store CLI
      "python"
      "go"
      "rust"
      "gradle"
      "maven"
      "ansible"
      "gh"  # GitHub CLI
    ];
    
    # Các ứng dụng cơ bản
    casks = [
      "google-chrome"
      "visual-studio-code"
      "iterm2"
      "slack"
      "zoom"
      "docker"
      "rectangle"  # Quản lý cửa sổ
      "alfred"     # Launcher
      "1password"  # Quản lý mật khẩu
      "jetbrains-toolbox"  # IDE JetBrains
      "notion"     # Ghi chú
      "spotify"    # Nghe nhạc
      
      # Fonts
      "font-jetbrains-mono"
      "font-fira-code"
      "font-hack-nerd-font"
    ];

    masApps = {
      "Xcode" = 497799835;
    };
  };
}