#/etc/nixos/modules/homemanager/shellInit/index.nix
{ pkgs, lib, defaultShell, ... }:

let
  shellInit = if defaultShell == "bash" then import ./bashInit.nix else
              if defaultShell == "zsh" then import ./zshInit.nix else
              if defaultShell == "fish" then import ./fishInit.nix else
              if defaultShell == "tcsh" then import ./tcshInit.nix else
              if defaultShell == "dash" then import ./dashInit.nix else
              if defaultShell == "ksh" then import ./kshInit.nix else
              if defaultShell == "mksh" then import ./mkshInit.nix else
              if defaultShell == "xonsh" then import ./xonshInit.nix else import ./bashInit.nix;
in
{
  inherit (shellInit) programs;
}
