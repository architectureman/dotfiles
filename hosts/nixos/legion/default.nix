{ config, lib, pkgs, hostname, username, inputs, ... }:

{
  # Import các file cấu hình hiện có
  imports = [
    # Cấu hình hệ thống với tham số
    (import ./configuration.nix { inherit config pkgs hostname username; })
    
    # Cấu hình phần cứng
    ./hardware-configuration.nix
    
    # Hardware profile cho Lenovo Legion
    # inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h
  ];
  
  # Ghi đè hostname để đảm bảo nhất quán
  networking.hostName = hostname;
  
  # Quản lý năng lượng và nhiệt cho laptop gaming
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  
  # Cấu hình Card đồ họa - UPDATED to use hardware.graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" "nvidia" ];
  boot.kernelPackages = pkgs.linuxPackages;

  # Hỗ trợ NVIDIA với offload mode ưu tiên hơn cấu hình từ nixos-hardware
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Add offload configuration with mkForce
    prime = {
      offload.enable = lib.mkForce true;  # Using mkForce to override nixos-hardware
      amdgpuBusId = "PCI:6:0:0";  # Update with your actual values
      nvidiaBusId = "PCI:1:0:0";  # Update with your actual values
    };
  };
  
  # Cấu hình Audio - FIXED conflicting settings
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Hỗ trợ Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  # Các gói đặc thù cho Legion
  environment.systemPackages = with pkgs; [
    git
    zsh
    oh-my-zsh

    # Công cụ quản lý laptop
    powertop
    s-tui
    
    # Công cụ đồ họa
    glxinfo
    vulkan-tools
    
    # Tiện ích Legion
    lm_sensors
    acpi
  ];

  # Cấu hình Zsh - FIXED enableCompletions issue
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    # Update oh-my-zsh to ohMyZsh (camelCase)
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "macos" "docker" "vscode" "npm" "yarn" ];
    };
    
    # Shell aliases
    shellAliases = {
      ll = "eza -l --icons";
      la = "eza -la --icons";
      cat = "bat";
      top = "htop";
      g = "git";
    };
  };

  # Environment variables in global configuration
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "code";
    PATH = "$HOME/.local/bin:$PATH";
    HISTSIZE = "10000";
    SAVEHIST = "10000";
    LANG = "en_US.UTF-8";
  };

  # Shell initialization
  environment.shellInit = ''
    # FZF integration for all shells that support it
    if [ -n "$(command -v fzf)" ]; then
      if [ -n "$ZSH_VERSION" ]; then
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      fi
    fi
  '';

  # Welcome message
  environment.interactiveShellInit = ''
    if [ -n "$ZSH_VERSION" ]; then
      echo "Welcome to your NixOS development environment, Mike!"
    fi
  '';

  # Hỗ trợ phần cứng
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  
  # Cấu hình bàn phím
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # UPDATED: Renamed from services.xserver.libinput to services.libinput
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      disableWhileTyping = true;
    };
  };
  
  # Tối ưu hóa kernel cho máy gaming
  boot.kernelParams = [
    "amd_pstate=active"
    "quiet"
    "splash"
    "loglevel=3"
    "udev.log_priority=3"
  ];
  
  # Tăng hiệu suất mạng
  networking.networkmanager.wifi.powersave = false;
  
  # Các cài đặt bổ sung
  programs.gamemode.enable = true;
  services.system76-scheduler.enable = true;
}