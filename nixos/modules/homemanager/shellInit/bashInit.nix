{
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      export PS1="\w > "
    '';
  };
}
