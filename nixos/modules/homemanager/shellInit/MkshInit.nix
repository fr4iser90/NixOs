{
  programs.mksh = {
    enable = true;
    interactiveShellInit = ''
      export PS1="\w > "
    '';
  };
}
