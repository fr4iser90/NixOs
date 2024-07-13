{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam 
    bash
    moonlight-qt
    discord 
    nix-diff
    vscode 
    fish 
    alacritty 
    kate  
    pkgs.pkgsi686Linux.libglvnd 
    lutris 
    wine 
    nss 
    wget 
    tree 
    git 
    pavucontrol 
    bitwarden-desktop 
    yad             
    libnotify        
    systemd
    libcap
    weston
#
    lsof             # Tool to list open files
#    net-tools        # Provides netstat and other network tools
    iproute2         # Replaces netstat, ifconfig, and route
    strace           # System call tracer
    gdb              # GNU Debugger
    htop             # Interactive process viewer
    curl             # Command line tool for transferring data with URLs
    ncdu             # Disk usage analyzer
    tcpdump          # Network packet analyzer
    iotop            # Display I/O usage by processes
    dstat            # Comprehensive system resource statistics
#    
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    pipewire
    libva
    xorg.xinput
    libva-utils
    util-linux
    xorg.libXtst
  ];

  virtualisation.docker.enable = true;
  
  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features for nix
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
