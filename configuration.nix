# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

let
  fallout = pkgs.fetchFromGitHub {
    owner = "shvchk";
    repo = "fallout-grub-theme";
    rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
    sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
  };

  ghostc = pkgs.callPackage ./ghostc.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      theme = fallout;
      useOSProber = true;
    };
    timeout = 10;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Tirane";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sq_AL.UTF-8";
    LC_IDENTIFICATION = "sq_AL.UTF-8";
    LC_MEASUREMENT = "sq_AL.UTF-8";
    LC_MONETARY = "sq_AL.UTF-8";
    LC_NAME = "sq_AL.UTF-8";
    LC_NUMERIC = "sq_AL.UTF-8";
    LC_PAPER = "sq_AL.UTF-8";
    LC_TELEPHONE = "sq_AL.UTF-8";
    LC_TIME = "sq_AL.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.slowking = {
    isNormalUser = true;
    description = "slowking";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "slowking";
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
     nerd-fonts.fira-code
     nerd-fonts.droid-sans-mono
     nerd-fonts.noto
     nerd-fonts.hack
     nerd-fonts.ubuntu
  ];

  environment.systemPackages = with pkgs; [
    # LSPs
    rust-analyzer
    nil
    stylua
    gopls
    typescript-language-server
    pyright
    bash-language-server
    lua-language-server

    # Docker
    docker

    # Formatters
    prettierd

    killall
    vim
    ripgrep
    wget
    spotify
    neovim
    git
    gh
    fastfetch
    sl
    lolcat
    tree

    # C / C++
    gcc
    clang
    gnumake
    cmake
    ninja
    gdb
    (pkgs."pkg-config")
    openssl

    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy

    #PHP
    php

    # Go
    go

    # Nodejs
    nodejs
    bun

    # Browser
    qutebrowser

    # Clipboard Provider
    xclip

    # Zsh extensions
    pkgs.zsh
    pkgs.zsh-completions
    pkgs.zsh-powerlevel10k
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-history-substring-search

    # Ghostty (if available)
    pkgs.ghostty

    # Ghostc (built from your GitHub repo)
    ghostc
    cmatrix
    btop

    # handy helper to prefetch git repos (requested)
    pkgs.nix-prefetch-git
  ];

  system.stateVersion = "25.05";

  hardware.graphics = { enable = true; };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    interactiveShellInit = "source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  programs.steam.enable = true;
}

