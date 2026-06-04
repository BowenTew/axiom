{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    "oh-my-zsh" = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "web-search" ];
    };

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      append = true;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignorePatterns = [ "pwd" "ls" "cd" ];
    };

    enableCompletion = true;

    shellAliases = {
      diff = "difft";
      ls = "ls -G";
      ll = "ls -la";
      la = "ls -a";
    };

    envExtra = ''
      export PATH="/opt/homebrew/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH"
      export PATH="$HOME/.npm-packages/bin:$HOME/bin:$PATH"
      export PATH="$HOME/.local/share/bin:$PATH"
      export NPM_CONFIG_PREFIX="$HOME/.npm-packages"
      export LIBRARY_PATH="${pkgs.libiconv}/lib:$LIBRARY_PATH"
      export CPATH="${pkgs.libiconv}/include:$CPATH"

      # Load local environment overrides if present
      if [[ -f "$HOME/.zshenv.local" ]]; then
        source "$HOME/.zshenv.local"
      fi
    '';

    initContent = lib.mkBefore ''
      # This script initializes the environment for the Nix package manager.

      # Check if the specified file exists and is a regular file.
      # This file is part of a standard Nix multi-user installation.
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # Source (execute) the nix-daemon.sh script in the current shell session.
        # This script sets up environment variables and paths necessary for the
        # Nix daemon, which manages builds and packages in a multi-user setup.
        # It typically adds the Nix binary directory to the PATH.
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        # Source the nix.sh script in the current shell session.
        # This script sets up essential user-specific Nix environment variables.
        # The most important one is NIX_PATH, which tells Nix where to look for
        # expressions (like nixpkgs). It may also configure other settings.
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Ensure npm package directory exists
      mkdir -p "$HOME/.npm-packages/bin"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Load local interactive overrides if present
      if [[ -f "$HOME/.zshrc.local" ]]; then
        source "$HOME/.zshrc.local"
      fi
    '';
  };
}
