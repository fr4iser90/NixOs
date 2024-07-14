{
  programs.ksh = {
    enable = true;
    interactiveShellInit = ''
      export PS1="\w > "
    '';
  };
}
