{ pkgs, inputs, ... }:

let
  # Rust 完整工具链（通过 fenix 提供，包含 rust-src，使用 USTC 镜像加速下载）
  fenixPkgs = inputs.fenix.packages.${pkgs.system};
  rust-toolchain = (fenixPkgs.toolchainOf {
    channel = "stable";
    date = "2025-09-18";
    sha256 = "sha256-SJwZ8g0zF2WrKDVmHrVG3pD2RGoQeo24MEXnNx5FyuI=";
    root = "https://mirrors.ustc.edu.cn/rust-static/dist";
  }).withComponents [
    "cargo"
    "clippy"
    "rustc"
    "rustfmt"
    "rust-src"
    "rust-analyzer"
  ];

  # 语言开发环境
  GO_DEVELOPMENT_PACKAGES = with pkgs; [
    go
    gotags
    gopls
    delve
    go-tools
    gotestsum
  ];

  RUST_DEVELOPMENT_PACKAGES = [
    rust-toolchain
  ];

  JAVASCRIPT_DEVELOPMENT_PACKAGES = with pkgs; [
    nodejs_22
    pnpm
  ];

  PYTHON_PACKAGES = with pkgs; [
    uv
    python3
  ];

  LUA_PACKAGES = with pkgs; [
    lua
    luarocks
  ];

  # 基础开发工具
  DEVELOPMENT_PACKAGES = with pkgs; [
    yazi
    tmux
    git
    git-lfs
    tig
    ripgrep
    wget
    fd
    fzf
    universal-ctags
    neovim
    gcc
    gnumake
    lazygit
    chezmoi
    helix
    dockerfile-language-server-nodejs
  ];

  # 系统工具
  SYSTEM_PACKAGES = with pkgs; [
    bat
    tree
    coreutils
    zip
    unzip
  ];


  # 所有包组合
  HOME_MANAGER_PACKAGE_GROUPS = [
    GO_DEVELOPMENT_PACKAGES
    RUST_DEVELOPMENT_PACKAGES
    JAVASCRIPT_DEVELOPMENT_PACKAGES
    DEVELOPMENT_PACKAGES
    SYSTEM_PACKAGES
    PYTHON_PACKAGES
    LUA_PACKAGES
  ];
in
pkgs.lib.concatLists HOME_MANAGER_PACKAGE_GROUPS
