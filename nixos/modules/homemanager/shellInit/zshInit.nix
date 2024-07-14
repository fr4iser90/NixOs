{
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      PROMPT="%~ > "
    '';
  };
}
