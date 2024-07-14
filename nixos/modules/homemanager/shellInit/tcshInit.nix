{
  programs.tcsh = {
    enable = true;
    interactiveShellInit = ''
      set prompt = "%~ > "
    '';
  };
}
