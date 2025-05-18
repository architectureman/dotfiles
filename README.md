# Dotfiles Đa Nền Tảng

Dự án này cung cấp bộ cấu hình dotfiles đa nền tảng, tự động phát hiện và thiết lập môi trường phù hợp cho NixOS, macOS, Ubuntu và WSL. Dự án được thiết kế để dễ dàng chia sẻ trong team và duy trì môi trường phát triển nhất quán.

## Tính Năng Chính

- **Tự động phát hiện hệ thống** - Tự động phát hiện và áp dụng cấu hình phù hợp
- **Hỗ trợ đa nền tảng** - NixOS, NixOS trên WSL, macOS và Ubuntu
- **Tích hợp liền mạch** - Nix, Homebrew, Home Manager và Snapd
- **Động và mở rộng** - Dễ dàng thêm máy mới và người dùng mới
- **Một lệnh thiết lập** - Cài đặt và cấu hình toàn bộ hệ thống với một lệnh duy nhất

## Cài Đặt Nhanh

```bash
# Clone repository
git clone https://github.com/username/dotfiles.git
cd dotfiles

# Cài đặt tự động (phát hiện hệ thống và thiết lập)
./install.sh
```

## Cấu Trúc Dự Án

```
dotfiles/
├── flake.nix                    # Cấu hình flake chính
├── install.sh                   # Script cài đặt tự động
├── README.md                    # Tài liệu này
├── lib/                         # Thư viện tiện ích
│   └── default.nix              # Hàm tiện ích và phát hiện hệ thống
├── hosts/                       # Cấu hình theo máy
│   ├── common/                  # Cấu hình chung
│   ├── nixos/                   # Cấu hình NixOS
│   ├── wsl/                     # Cấu hình WSL
│   ├── darwin/                  # Cấu hình macOS
│   └── ubuntu/                  # Cấu hình Ubuntu
└── home/                        # Cấu hình Home Manager
    ├── nixos.nix                # Cấu hình Home Manager cho NixOS
    ├── darwin.nix               # Cấu hình Home Manager cho macOS
    ├── ubuntu.nix               # Cấu hình Home Manager cho Ubuntu
    ├── wsl.nix                  # Cấu hình Home Manager cho WSL
    └── profiles/                # Hồ sơ người dùng
        ├── rnd/                 # Profile cho user rnd
        └── mike/                # Profile cho user mike
```

## Hướng Dẫn Cài Đặt Chi Tiết

### NixOS

1. Clone repository:
   ```bash
   git clone https://github.com/username/dotfiles.git
   cd dotfiles
   ```

2. Cài đặt tự động:
   ```bash
   ./install.sh
   ```

3. Hoặc cài đặt thủ công:
   ```bash
   # Bật Nix flakes nếu chưa có
   sudo mkdir -p /etc/nix
   echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

   # Xây dựng cấu hình
   sudo nixos-rebuild switch --flake .#hostname
   ```

### macOS

1. Clone repository:
   ```bash
   git clone https://github.com/username/dotfiles.git
   cd dotfiles
   ```

2. Cài đặt tự động:
   ```bash
   ./install.sh
   ```

3. Hoặc cài đặt thủ công:
   ```bash
   # Cài đặt Nix nếu chưa có
   sh <(curl -L https://nixos.org/nix/install) --daemon
   
   # Cài đặt nix-darwin nếu chưa có
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   
   # Xây dựng cấu hình
   darwin-rebuild switch --flake .#hostname
   ```

### Ubuntu

1. Clone repository:
   ```bash
   git clone https://github.com/username/dotfiles.git
   cd dotfiles
   ```

2. Cài đặt tự động:
   ```bash
   ./install.sh
   ```

3. Hoặc cài đặt thủ công:
   ```bash
   # Cài đặt Nix nếu chưa có
   sh <(curl -L https://nixos.org/nix/install) --daemon
   
   # Bật flakes
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
   
   # Cài đặt home-manager
   nix-shell -p nixFlakes --run "nix run github:nix-community/home-manager/release-24.11 -- switch --flake .#username@hostname"
   ```

### NixOS trên WSL

1. Clone repository:
   ```bash
   git clone https://github.com/username/dotfiles.git
   cd dotfiles
   ```

2. Cài đặt tự động:
   ```bash
   ./install.sh
   ```

3. Hoặc cài đặt thủ công:
   ```bash
   # Bật flakes
   sudo mkdir -p /etc/nix
   echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
   
   # Xây dựng cấu hình
   sudo nixos-rebuild switch --flake .#wsl
   ```

## Quản Lý Hệ Thống và Người Dùng Động

### Phát Hiện Hệ Thống

Dự án tự động phát hiện hostname, username và hệ điều hành. Bạn có thể ghi đè bằng biến môi trường:

```bash
HOSTNAME=custom-hostname USERNAME=custom-username ./install.sh
```

### Thêm Người Dùng Mới

1. Tạo thư mục profile mới:
   ```bash
   cp -r home/profiles/template home/profiles/new-username
   ```

2. Chỉnh sửa thông tin cá nhân:
   ```bash
   vim home/profiles/new-username/default.nix
   ```

### Thêm Máy Mới

#### NixOS

1. Tạo thư mục cấu hình mới:
   ```bash
   mkdir -p hosts/nixos/new-hostname
   ```

2. Tạo cấu hình phần cứng:
   ```bash
   nixos-generate-config --dir hosts/nixos/new-hostname
   ```

3. Chỉnh sửa cấu hình:
   ```bash
   vim hosts/nixos/new-hostname/configuration.nix
   ```

#### macOS

1. Tạo thư mục cấu hình mới:
   ```bash
   mkdir -p hosts/darwin/new-hostname
   ```

2. Tạo file cấu hình:
   ```bash
   cp hosts/darwin/default.nix hosts/darwin/new-hostname/default.nix
   ```

3. Chỉnh sửa cấu hình:
   ```bash
   vim hosts/darwin/new-hostname/default.nix
   ```

## Tích Hợp với Các Công Cụ Bản Địa

### Homebrew trên macOS

File `hosts/darwin/default.nix` chứa cấu hình Homebrew. Bạn có thể thêm các gói và ứng dụng:

```nix
homebrew = {
  enable = true;
  brews = [ "mas" "python" ];  # CLI tools
  casks = [ "firefox" "visual-studio-code" ];  # GUI apps
};
```

### Snapd trên Ubuntu

File `home/ubuntu.nix` chứa cấu hình Snapd. Bạn có thể thêm các gói snap:

```nix
home.activation.snapPackages = ''
  PACKAGES=("code" "spotify" "slack")
  for pkg in "''${PACKAGES[@]}"; do
    if ! snap list | grep -q "^$pkg"; then
      sudo snap install $pkg
    fi
  done
'';
```

## Cập Nhật Hệ Thống

### NixOS

```bash
cd dotfiles
git pull
sudo nixos-rebuild switch --flake .#hostname
```

### macOS

```bash
cd dotfiles
git pull
darwin-rebuild switch --flake .#hostname
```

### Ubuntu

```bash
cd dotfiles
git pull
nix run home-manager/release-24.11 -- switch --flake .#username@hostname
```

## FAQ & Troubleshooting

### Nix flakes không hoạt động

Đảm bảo đã bật tính năng thử nghiệm:

```bash
# NixOS
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# macOS / Ubuntu
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### Không tìm thấy host hoặc user

Kiểm tra cấu hình flake.nix và đảm bảo hostname và username khớp với cấu hình hoặc sử dụng cấu hình động.

### Xung đột Homebrew

Nếu gặp xung đột giữa Nix và Homebrew, đảm bảo đường dẫn đúng:

```bash
export PATH=/usr/local/bin:$PATH  # Homebrew Intel
# hoặc
export PATH=/opt/homebrew/bin:$PATH  # Homebrew Apple Silicon
```

### Lỗi trên Ubuntu

Đảm bảo đã cài đặt các gói tiên quyết:

```bash
sudo apt update
sudo apt install -y curl git build-essential
```

## Đóng Góp

Vui lòng đóng góp và báo lỗi qua GitHub Issues hoặc gửi Pull Request.

## Giấy Phép

MIT License