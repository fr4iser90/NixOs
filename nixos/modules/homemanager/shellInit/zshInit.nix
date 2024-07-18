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
    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"

        # Set name of the theme to load.
        ZSH_THEME="agnoster"

        # Enable Powerlevel10k theme (if installed)
        #ZSH_THEME="powerlevel10k/powerlevel10k"

        # Which plugins would you like to load?
        plugins=(
          git
          ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
          ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting
          ${pkgs.zsh-autocomplete}/share/zsh-autocomplete
          ${pkgs.zsh-you-should-use}/share/zsh-you-should-use
          ${pkgs.zsh-navigation-tools}/share/zsh-navigation-tools
          ${pkgs.zsh-system-clipboard}/share/zsh-system-clipboard
          ${pkgs.nix-zsh-completions}/share/nix-zsh-completions
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

        # Enable autojump
        if [ -f /usr/share/autojump/autojump.zsh ]; then
          . /usr/share/autojump/autojump.zsh
        fi
      '';
    };
  };
}
