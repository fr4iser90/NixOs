{ config, pkgs, ... }:

let
  env = import ../../../env.nix;
in
{
  programs.bash.enable = env.enableBash;
  programs.zsh.enable = env.enableZsh;
  programs.fish.enable = env.enableFish;
  programs.tcsh.enable = env.enableTcsh;
  programs.dash.enable = env.enableDash;
  programs.ksh.enable = env.enableKsh;
  programs.mksh.enable = env.enableMksh;
  programs.xonsh.enable = env.enableXonsh;
}
