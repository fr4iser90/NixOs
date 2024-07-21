#/etc/nixos/modules/packages/setup/workspace.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    lsof
    git
    wget
    tree
    vlc
    fish
    kitty
    vscode
    bitwarden-cli
    qtcreator
    geany
    eclipses.eclipse-sdk
    android-studio
    kate
    emacs
    vim
    neovim
    docker
    kubectl
    terraform
    ansible
    vagrant
    heroku
    awscli
    gdb
    cmake
    bazel
    maven
    gradle
    nodejs
    yarn
    kitty
    python3
    jellyfin-media-player      
    owncloud-client
    ruby
    go
    rustup
    php
    perl
    elixir
    racket
    julia
    sbcl
    lua
    plex
    slack
    zoom-us
    mattermost-desktop
    telegram-desktop
    signal-desktop
    thunderbird
    remmina
];

  virtualisation.docker.enable = true;
  programs.npm.enable = true;
  programs.steam.enable = true;
  programs.firefox.enable = true;
}