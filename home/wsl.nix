{ config, pkgs, system, inputs, hostname, username, ... }:

{
  # Import hồ sơ người dùng
  imports = [ ./profiles/${username} ];

  
  # Thông tin cơ bản
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  # Các gói cơ bản cho WSL
  home.packages = with pkgs; [
    git
    curl
    wget
    ripgrep
    fd
    jq
    wslu  # Tiện ích WSL
    wsl-open  # Mở file Windows từ WSL
    wsl-clipboard  # Tích hợp clipboard
  ];

  # Cấu hình shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "wsl" "docker" ];
    };
    
    # Tích hợp Windows
    initExtra = ''
      # Đường dẫn Windows
      export PATH=$PATH:/mnt/c/Windows/System32:/mnt/c/Windows
      
      # Mở các ứng dụng Windows
      alias explorer="explorer.exe"
      alias code="code.exe"
      
      # Tích hợp WSL
      export BROWSER="wslview"
    '';
  };
  
  # Tích hợp VSCode giữa WSL và Windows
  programs.vscode = {
    enable = true;
    extensions = [
      # Các extension có thể được cài đặt qua Remote WSL
    ];
  };
  
  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}