{ pkgs, ... }:
{
  home.stateVersion = "25.05";

  # Pacotes do usuário (CLI tools, etc.)
  home.packages = with pkgs; [
    oh-my-posh
    ripgrep
    fd
    fzf
    gh
    neovim
    lazygit
    xclip
    asdf-vm
    curl
    git
    unzip
    nixd
    nixfmt
    nodejs_latest
    bun
    awscli2
    dbeaver-bin
    nil
    opencode-desktop
    colima
    docker
    docker-compose
    docker-buildx
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  # Configuração declarativa de programas
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Caio Fernando";
        email = "caiofsr@proton.me";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/spaceship.omp.json')"

      export AWS_PROFILE=secrets
      export PATH="$HOME/.npm-global/bin:$PATH"
    '';
    shellAliases = {
      nix-rebuild = "sudo darwin-rebuild switch --flake /etc/nix-darwin";
      nix-update = "cd /etc/nix-darwin && nix flake update && sudo darwin-rebuild switch --flake . && cd -";
      nix-cleanup = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nix-edit = "zed /etc/nix-darwin";
      vi = "nvim";
      vim = "nvim";
      dev = "cd ~/Development";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
    });
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
