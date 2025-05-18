{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  # Phát hiện WSL (di chuyển lên đầu)
  isWSL = 
    if builtins.pathExists "/proc/sys/kernel/osrelease" then
      lib.hasInfix "microsoft" (builtins.readFile "/proc/sys/kernel/osrelease")
    else
      false;

  # Phát hiện Ubuntu (di chuyển lên đầu)
  isUbuntu =
    if builtins.pathExists "/etc/os-release" then
      lib.hasInfix "Ubuntu" (builtins.readFile "/etc/os-release")
    else
      false;
in
{
  # Phát hiện hostname
  getHostName = let
    fallback = "default-host";
  in
    if builtins.pathExists "/etc/hostname" then
      builtins.readFile "/etc/hostname"
    else if builtins.getEnv "HOSTNAME" != "" then
      builtins.getEnv "HOSTNAME"
    else
      fallback;

  # Phát hiện username
  getUserName = let
    fallback = "default-user";
  in
    if builtins.getEnv "USER" != "" then
      builtins.getEnv "USER"
    else if builtins.getEnv "USERNAME" != "" then
      builtins.getEnv "USERNAME"
    else
      fallback;

  # Phát hiện hệ thống
  detectSystem = 
    let
      isMac = builtins.match ".*darwin.*" (builtins.currentSystem or "");
      isLinux = builtins.match ".*linux.*" (builtins.currentSystem or "");
    in
      if isMac != null then "darwin"
      else if isLinux != null then
        if builtins.pathExists "/etc/NIXOS" then
          if isWSL then "nixos-wsl" else "nixos"
        else if isUbuntu then "ubuntu"
        else "unknown-linux"
      else "unknown";

  # Xuất biến isWSL và isUbuntu
  inherit isWSL isUbuntu;
  
  # Các hàm tiện ích khác 
  mkHomeManagerConfig = { username, hostname, systemType ? "linux" }:
    let
      systemArch = if systemType == "darwin" then "x86_64-darwin"
                   else "x86_64-linux";
    in {
      username = username;
      homeDirectory = 
        if systemType == "darwin" then "/Users/${username}"
        else "/home/${username}";
      platform = systemType;
      system = systemArch;
    };
}