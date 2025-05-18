{ config, pkgs, system, inputs, hostname, username, ... }:

{
  # Import hồ sơ người dùng
  imports = [ ./profiles/${username} ];
  
  # Thông tin cơ bản
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  # Các gói cơ bản cho NixOS
  home.packages = with pkgs; [
    git
    gitbutler
    vscode
    ghostty
    oh-my-zsh
    inputs.zen-browser.packages.${system}.default
  ];

  # Cấu hình shell
  programs.zsh.enable = true;
  
  # Cấu hình Git
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };
  
  # Cấu hình Editor
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  
  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}