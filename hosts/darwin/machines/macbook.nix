{ config, lib, pkgs, hostname ? "macbook", ... }:

{
  # Hostname
  networking.hostName = hostname;
  
  # Cài đặt môi trường cụ thể cho macbook
  environment.systemPackages = with pkgs; [    
    # Công cụ macOS
    m-cli  # Tiện ích CLI cho macOS
    mas    # Mac App Store CLI
  ];
  
  # Dịch vụ macbook
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      window_placement = "second_child";
      window_opacity = "off";
      window_topmost = "off";
      window_shadow = "on";
      window_border = "off";
      split_ratio = 0.50;
      auto_balance = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };
    extraConfig = ''
      # Làm mờ cửa sổ không tập trung
      yabai -m config window_opacity on
      yabai -m config active_window_opacity 1.0
      yabai -m config normal_window_opacity 0.9
      
      # Loại trừ các ứng dụng
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
    '';
  };
  
  # Thiết lập riêng cho macbook
  system.defaults = {
    dock = {
      orientation = "bottom";
      showhidden = true;
      mineffect = "scale";
      static-only = true;
      tilesize = 48;
    };
    
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
    };
    
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
    };
  };
}