#/etc/nixos/modules/homemanager/shellInit/fishInit.nix
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_prompt
        echo -n (prompt_pwd)
        echo -n ' > '
      end
    '';
  };
}
