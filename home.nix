{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.caelestia.homeManagerModules.default
    inputs.hyprshell.homeModules.hyprshell
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alexandre";
  home.homeDirectory = "/home/alexandre";

  #####################
  ##### PROGRAMS ######
  #####################
  programs.hyprshell = {
    enable = true;
    # Utilise la version nixpkgs si tu ne veux pas recompiler 10 ans
    package = inputs.hyprshell.packages.x86_64-linux.hyprshell-nixpkgs;

    settings = {
      windows = {
        enable = false;
        switch.enable = true;
      };
    };
  };

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec-once = hyprctl plugin load ${pkgs.hyprlandPlugins.hypr-dynamic-cursors.outPath}/lib/libhypr-dynamic-cursors.so

      ${builtins.readFile ./dotfiles/hypr/hyprland.conf}
      ${builtins.readFile ./dotfiles/hypr/plugins.conf}
      ${builtins.readFile ./dotfiles/hypr/startup.conf}
      ${builtins.readFile ./dotfiles/hypr/binding.conf}
      ${builtins.readFile ./dotfiles/hypr/ui.conf}
    '';
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false; # L'auto-complétion à la Fish
    syntaxHighlighting.enable = true; # Les commandes en couleur
    historySubstringSearch.enable = true;
    oh-my-zsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" ];
      };

      # C'est ici qu'on force l'init de Starship si le module Nix a un raté
      initContent = ''
        eval "$(starship init zsh)"
      '';
  };

  # Le prompt du turfu (compatible Zsh, Fish, Bash)
  programs.starship = {
    enable = true;
    # Optionnel : configurer Starship pour être discret
    settings = {
      add_newline = false;
      php.symbol = "🐘 ";
    };
  };

  # Packages
  home.packages = with pkgs; [
    gnumake  # Le standard pour tes Makefile
    nodejs_20 # Ou nodejs tout court pour la LTS

    # Terminaux et utilitaires système perso
    kitty
    fastfetch
    htop

    quickshell

    vesktop # discord

    # Apps de travail / Browsing
    vscode
    zed-editor
    brave
    rocketchat-desktop
    jetbrains.phpstorm

    #Stack dev de con
    php84
    php84Packages.composer
    php84Extensions.gd
    php84Extensions.intl
    # JS / shit
    biome
    bun
    oxlint

    docker

    # à configurer pour faire un truc ouebeb
    thunar
    tumbler
    thunar-archive-plugin # Pour extraire les .zip d'un clic droit
    thunar-volman

    hyprlandPlugins.hypr-dynamic-cursors

    grim          # Pour les screenshots
    slurp         # Pour sélectionner la zone (indispensable pour les deux)
    wf-recorder   # Pour le record vidéo
    libnotify     # Pour les petites notifications en haut à droite
    wl-clipboard  # Pour copier direct dans le presse-papier

    papirus-icon-theme # pour des icones full oe
    nautilus # on sait jamais
    sushi
    file-roller # voir les zip dans dezipp
  ];

  # Pour avoir magento-cloud & opencode en cli
  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.magento-cloud/bin"
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    #".config/caelestia/shell.json".source = ./dotfiles/caelestia/shell.json;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alexandre/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.85";
      dynamic_background_opacity = true; # Permet de changer à la volée
    };
  };

  # NEVER CHANGE
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
}
