#/etc/nixos/modules/homemanager/shellInit/bashInit.nix
 {
   programs.bash = {
     enable = true;
     interactiveShellInit = ''
       export PS1="\w > "
     '';
   };
 }

#{
#  programs.bash.enable = true;
#  programs.bash.interactiveShellInit = ''
#      export PS1="\w > "
#    '';
#}
