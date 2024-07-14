#/etc/nixos/modules/homemanager/shellInit/bashInit.nix
 {
   programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\w > "
    '';
  };
 }
