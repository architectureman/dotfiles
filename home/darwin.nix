{ config, lib, pkgs, system, inputs, hostname, username, ... }:

{
  # Import hồ sơ người dùng
  imports = [ ./profiles/${username} ];
  
  # Thông tin cơ bản
  home.username = username;
  home.homeDirectory = lib.mkForce "/Users/${username}";
  
  # Các gói cơ bản cho macOS
  home.packages = with pkgs; [

  ];

  # Cấu hình shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "macos" "docker" ];
    };
  };
  
  # Cấu hình Git
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };
  
  # Cấu hình Terminal
  programs.alacritty.enable = true;
  
  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}