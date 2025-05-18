# hosts/common/default.nix
{ config, lib, pkgs, ... }:

{
  # Cấu hình chung cho tất cả hệ thống
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Cấu hình chung khác
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
  ];
}