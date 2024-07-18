# /etc/nixos/modules/homemanager/shellInit/bashInit.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash
    bash-completion
    fzf
    blesh
  ];

  programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\[\033[01;34m\]\w\[\033[00m\] > "

      # Load ble.sh
      if [ -f ${pkgs.blesh}/share/blesh/ble.sh ]; then
        source ${pkgs.blesh}/share/blesh/ble.sh --attach=none
      fi

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

      # History configuration
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      shopt -s histappend
      export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

      # Enable bash completion for paths
      shopt -s direxpand
      shopt -s dirspell
      shopt -s cdspell

      # Colorful grep output
      alias grep='grep --color=auto'

      # Some useful aliases
      alias ll='ls -lah'
      alias la='ls -A'
      alias l='ls -CF'

      # Autojump if installed
      if command -v autojump >/dev/null 2>&1; then
        . /usr/share/autojump/autojump.sh
      fi

      # Git prompt if installed
      if [ -f /etc/bash_completion.d/git-prompt ]; then
        . /etc/bash_completion.d/git-prompt
        export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)") > '
      fi

      # Direnv if installed
      if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook bash)"
      fi
    '';
  };
}
