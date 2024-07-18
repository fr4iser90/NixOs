#/etc/nixos/modules/homemanager/shellInit/fishInit.nix
{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Set up a custom prompt
      function fish_prompt
        set_color blue
        echo -n (prompt_pwd)
        set_color normal
        echo -n ' > '
      end

      # Enable syntax highlighting
      if status is-interactive
        source (fish_config theme save --only fish_prompt.fish)
        source /etc/fish/config.fish
        source ~/.config/fish/conf.d/*
        source ~/.config/fish/functions/*
      end

      # Enable autosuggestions
      if not functions -q fish_update_completions
        echo "Installing Fisher..."
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        fisher install jethrokuan/fzf
        fisher install jorgebucaran/autopair.fish
        fisher install jorgebucaran/replay.fish
        fisher install edc/bass
        fisher install IlanCosman/tide@v5
      end

      # Load custom aliases
      if test -f ~/.config/fish/aliases.fish
        source ~/.config/fish/aliases.fish
      end

      # Set up history
      set -U fish_history (commandline -P)
      set -U fish_history (history --save)

      # Useful aliases
      alias ll='ls -lah'
      alias la='ls -A'
      alias l='ls -CF'
      alias grep='grep --color=auto'

      # Load Fisher for managing Fish plugins
      if not functions -q fisher
        echo "Installing Fisher..."
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
      end

      # Install and configure Tide prompt
      if not functions -q tide
        fisher install IlanCosman/tide@v5
        tide configure
      end

      # Autojump if installed
      if command -v autojump >/dev/null 2>&1
        eval (autojump init fish)
      end

      # Git prompt if installed
      if type -q __fish_git_prompt
        function fish_prompt
          set_color green
          echo -n (whoami) '@' (hostname) ' '
          set_color cyan
          echo -n (prompt_pwd)
          set_color yellow
          echo -n (__fish_git_prompt)
          set_color normal
          echo -n ' > '
        end
      end

      # Direnv if installed
      if type -q direnv
        eval (direnv hook fish)
      end
    '';
  };
}

