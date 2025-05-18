{ config, lib, pkgs, ... }:

{
  # Hướng dẫn cài đặt cho hệ thống Ubuntu
  home.activation.ubuntuSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Thiết lập Nix
    if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
      mkdir -p ~/.config/nix
      echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    fi
    
    # Cài đặt các gói Ubuntu cần thiết
    if command -v apt &>/dev/null; then
      echo "Cài đặt các gói Ubuntu cần thiết..."
      sudo apt update
      sudo apt install -y curl git build-essential
    fi
    
    # Cài đặt snapd nếu chưa có
    if ! command -v snap &>/dev/null; then
      echo "Cài đặt snapd..."
      sudo apt install -y snapd
    fi
    
    # Cài đặt các gói snap
    if command -v snap &>/dev/null; then
      echo "Cài đặt các gói snap..."
      
      # Danh sách gói snap cần cài đặt
      SNAP_PACKAGES=("code" "firefox" "spotify")
      
      for pkg in "''${SNAP_PACKAGES[@]}"; do
        if ! snap list | grep -q "^$pkg"; then
          echo "Đang cài đặt $pkg..."
          sudo snap install $pkg
        else
          echo "$pkg đã được cài đặt"
        fi
      done
    fi
  '';
}