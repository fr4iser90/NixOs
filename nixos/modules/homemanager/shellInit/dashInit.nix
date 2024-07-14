{
  programs.dash = {
    enable = true;
    interactiveShellInit = ''
      export PS1="\w > "
    '';
  };
}
