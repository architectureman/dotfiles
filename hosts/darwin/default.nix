{ config, lib, pkgs, hostname, username, ... }:

{
  # Import tất cả module theo thứ tự
  imports = [
    # Cấu hình macOS cơ bản
    ./base.nix
    
    # Cấu hình Homebrew
    ./homebrew.nix

    # Cấu hình cho XCode  
    ./xcode.nix
    
    # Import cấu hình cụ thể cho máy
    # Import động dựa trên hostname
    ./machines/${hostname}.nix
  ];
}