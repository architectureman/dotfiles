{ config, pkgs, system, inputs, hostname, username, ... }:

{
  # Import hồ sơ người dùng
  imports = [ ./profiles/${username} ];
  
  # Thông tin cơ bản
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  # Các gói cơ bản cho Ubuntu
  home.packages = with pkgs; [
    git
    curl
    wget
    ripgrep
    fd
    jq
    tree
    htop
    neofetch
    bat
    exa
    fzf
  ];

  # Cấu hình shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "ubuntu" "docker" ];
    };
  };
  
  # Cấu hình Editor
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = [
      pkgs.vscode-extensions.ms-vscode.cpptools
      pkgs.vscode-extensions.ms-python.python
    ];
  };
  
  # Tích hợp với snapd
  home.activation.snapPackages = config.lib.dag.entryAfter ["writeBoundary"] ''
    if command -v snap > /dev/null 2>&1; then
      echo "Cài đặt các gói snap..."
      
      # Danh sách các gói snap cần cài đặt
      PACKAGES=("code" "spotify" "slack")
      
      for pkg in "''${PACKAGES[@]}"; do
        if ! snap list | grep -q "^$pkg"; then
          echo "Đang cài đặt $pkg..."
          sudo snap install $pkg
        fi
      done
    fi
  '';
  
  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}