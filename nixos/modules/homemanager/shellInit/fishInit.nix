
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
