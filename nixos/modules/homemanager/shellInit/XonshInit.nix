{
  programs.xonsh = {
    enable = true;
    interactiveShellInit = ''
      $PROMPT = '{cwd} > '
    '';
  };
}
