{ config, lib, pkgs, hostname, username, inputs, ... }:

{
  # Import các file cấu hình hiện có
  imports = [
    # Cấu hình hệ thống với tham số
    (import ./configuration.nix { inherit config pkgs hostname username; })
    
    # Cấu hình phần cứng
    ./hardware-configuration.nix
    
    # Hardware profile cho Lenovo Legion
    inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h
  ];
  
  # Ghi đè hostname để đảm bảo nhất quán
  networking.hostName = hostname;
  
  # Cấu hình bổ sung cho Legion
  
  # Quản lý năng lượng và nhiệt cho laptop gaming
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
  
  # Cấu hình Card đồ họa
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  # Hỗ trợ NVIDIA nếu có
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  # Hỗ trợ AMD GPU
  hardware.amdgpu = {
    enable = true;
    opencl = true;
  };
  
  # Cấu hình Audio
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  
  # Hỗ trợ Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  # Các gói đặc thù cho Legion
  environment.systemPackages = with pkgs; [
    # Công cụ quản lý laptop
    powertop
    s-tui
    
    # Công cụ đồ họa
    glxinfo
    vulkan-tools
    
    # Tiện ích Legion
    lm_sensors
    acpi
    
    # Driver và công cụ
    linuxKernel.packages.linux_zen.nvidia_x11
    amdvlk
  ];
  
  # Bật vulkan
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  
  # Hỗ trợ phần cứng
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  
  # Cấu hình bàn phím
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Hỗ trợ cảm ứng (nếu có)
  services.xserver.libinput = {
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
  
  # Tắt IPv6 nếu gây lag trong game
  # networking.enableIPv6 = false;
  
  # Tăng hiệu suất mạng
  networking.networkmanager.wifi.powersave = false;
  
  # Các cài đặt bổ sung
  programs.gamemode.enable = true;  # Tối ưu hiệu suất khi chơi game
  services.system76-scheduler.enable = true;  # Quản lý CPU
  
  # Về sau nếu cần thêm cấu hình đặc thù cho Legion, thêm vào đây
}