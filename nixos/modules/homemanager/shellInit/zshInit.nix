# /etc/nixos/modules/homemanager/shellInit/zshInit.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autocomplete
    zsh-you-should-use
    zsh-navigation-tools
    zsh-system-clipboard
    nix-zsh-completions
    oh-my-zsh
    autojump
  ];

  
  programs.zsh = {
    enable = true;
    syntaxHighlighting.highlighters = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [
        "git"
      ];
      extraConfig = ''
        #export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"

        # Set name of the theme to load.
        ZSH_THEME="agnoster"

        # Enable Powerlevel10k theme (if installed)
        #ZSH_THEME="powerlevel10k/powerlevel10k"

        # Which plugins would you like to load?
        plugins=(
        )

        source $ZSH/oh-my-zsh.sh

        # User configuration

        # Add env variables here

        # Customize prompt
        PROMPT="%~ > "

        # Add custom aliases
        alias ll='ls -lah'
        alias la='ls -A'
        alias l='ls -CF'
        alias buildNix='bash ~/Documents/nixos/build.sh'

        # Enable autojump
        if [ -f /usr/share/autojump/autojump.zsh ]; then
          . /usr/share/autojump/autojump.zsh
        fi
      '';
    };
  };
}
