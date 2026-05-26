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

  # Git 相关工具
  GIT_PACKAGES = with pkgs; [
    git
    tig
    git-lfs
    lazygit
  ];

  # 压缩工具
  ZIP_PACKAGES = with pkgs; [
    zip
    unzip
  ];

  # 文件查看与管理
  FILE_PACKAGES = with pkgs; [
    bat
    yazi
    tree
  ];

  # 编辑器
  EDITOR_PACKAGES = with pkgs; [
    neovim
    helix
    micro
  ];

  # 搜索工具
  SEARCH_PACKAGES = with pkgs; [
    fd
    fzf
    ripgrep
    universal-ctags
  ];

  # 编译构建工具
  BUILD_PACKAGES = with pkgs; [
    gcc
    gnumake
  ];

  # LSP 服务
  LSP_PACKAGES = with pkgs; [
    dockerfile-language-server-nodejs
  ];

  # 基础开发工具
  DEVELOPMENT_PACKAGES = with pkgs; [
    tmux
    wget
    chezmoi
  ];

  # 系统工具
  SYSTEM_PACKAGES = with pkgs; [
    coreutils
  ];

  # 所有包组合
  HOME_MANAGER_PACKAGE_GROUPS = [
    GO_DEVELOPMENT_PACKAGES
    RUST_DEVELOPMENT_PACKAGES
    JAVASCRIPT_DEVELOPMENT_PACKAGES
    PYTHON_PACKAGES
    LUA_PACKAGES
    GIT_PACKAGES
    ZIP_PACKAGES
    FILE_PACKAGES
    EDITOR_PACKAGES
    SEARCH_PACKAGES
    BUILD_PACKAGES
    LSP_PACKAGES
    DEVELOPMENT_PACKAGES
    SYSTEM_PACKAGES
  ];
in
pkgs.lib.concatLists HOME_MANAGER_PACKAGE_GROUPS
