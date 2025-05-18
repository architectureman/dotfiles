# home/profiles/template/default.nix
{ config, pkgs, system, inputs, ... }:

{
  # Thông tin cơ bản (sẽ được thay thế)
  home.username = "new-user";
  home.homeDirectory = "/home/new-user"; # Hoặc /Users/new-user trên macOS

  # Các gói cơ bản
  home.packages = with pkgs; [
    git
    curl
    wget
  ];

  # Cấu hình shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };

  # Phiên bản Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}