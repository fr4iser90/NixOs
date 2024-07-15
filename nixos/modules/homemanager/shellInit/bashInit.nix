#/etc/nixos/modules/homemanager/shellInit/bashInit.nix
{
  programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\w > "

      # Load bash-completion if available
      if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

      # Enable programmable completion features (if not already enabled)
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi

      # Load custom aliases
      if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
      fi
    '';
  };
}
