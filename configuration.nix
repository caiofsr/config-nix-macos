{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Plataforma
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "caiofernando";
  system.stateVersion = 5;

  # Touch ID no terminal
  security.pam.services.sudo_local.touchIdAuth = true;

  # Pacotes do sistema
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
  ];

  # Gerenciamento do Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      "protonpass/tap"
      "anomalyco/tap"
    ];

    brews = [
      "mas"
      "protonpass/tap/pass-cli"
      "mkcert"
      "anomalyco/tap/opencode"
    ];

    casks = [
      "zed"
      "visual-studio-code"
      "ghostty"
      "antigravity"
      "affine"
      "slack"
      "raycast"
      "freelens"
      "whatsapp"
      "ungoogled-chromium"
      "dockdoor"
      "orbstack"
      "codex"
      "helium"
    ];

    masApps = { };
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false; # Não reorganiza os Spaces
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    trackpad = {
      Clicking = true; # Tap to click
    };

    CustomUserPreferences = {
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # 64 é o código do Cmd+Space para Spotlight
          "64" = {
            enabled = false; # Desativa o atalho
          };
        };
      };
    };
  };

  # Tira o som de ligar o Mac
  system.startup.chime = false;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Usuário primário
  users.users.caiofernando = {
    name = "caiofernando";
    home = "/Users/caiofernando";
  };
}
