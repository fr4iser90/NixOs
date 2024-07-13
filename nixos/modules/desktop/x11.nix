#/etc/nixos/modules/desktop/x11.nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xorgserver   # The X.Org server, the foundation for the X11 display system.
    xorg.xhost        # Utility to control access to the X server.
    xorg.xinit        # Utility to initialize X11 sessions, commonly used to start X servers.
    xorg.xauth        # Utility to edit and manage X authentication credentials.
    xorg.xrdb         # Utility for managing the X server resource database.
    xorg.xrandr       # Utility to dynamically manage screen resolution and orientation.
    xorg.xsetroot     # Utility to set the root window background.
    xorg.xmodmap      # Utility to edit and manage keyboard key mappings.
    xorg.xset         # Utility to set various user preferences for the X server.
    glxinfo           # Utility to display information about the OpenGL and GLX implementations.
    libGL             # OpenGL library.
    mesa              # Open-source implementation of the OpenGL specification.
    libvdpau          # Video Decode and Presentation API for Unix.
    libva             # Video Acceleration API.
    #not essential
  #  xorg.xeyes        # Simple demonstration program for X11.
  #  xorg.xclock       # Simple clock for the X11 environment.
  #  xorg.xkill        # Utility to forcefully close an X11 application.
  #  xorg.xclipboard   # Utility to manage the X11 clipboard.
  #  xorg.xprop        # Utility to view and set X11 window properties.
  #  xorg.xev          # Utility to display X11 events.
  #  xorg.xdpyinfo     # Utility to display information about the X server.
  #  xorg.xrefresh     # Utility to refresh the X11 display.
  #  xorg.xbacklight   # Utility to manage screen backlight settings.
  ];
}
