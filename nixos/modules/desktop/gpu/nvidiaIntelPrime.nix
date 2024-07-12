# /etc/nixos/modules/desktop/nvidia.nix
{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ]; # got problems with nouveau, would give it another try
  services.xserver.xkb.layout = "de";  # Beispiel für Tastaturlayout
  services.xserver.xkb.options = "eurosign:e";
  # Enable Wayland if desired
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.displayManager.defaultSession = "plasma";

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true;
    prime = {
      sync.enable = true;
      # Multiple uses are available, check the NVIDIA NixOS wiki
      # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      config.boot.kernelPackages.nvidiaPackages.production
      pkgs.libvdpau
      pkgs.libva
    ];
  };

  # Install necessary X11 packages
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
    plasma-workspace  # KDE Plasma desktop workspace.
    glxinfo           # Utility to display information about the OpenGL and GLX implementations.
    libGL             # OpenGL library.
    mesa              # Open-source implementation of the OpenGL specification.
  ];  

  # NVIDIA driver options (uncomment to use a different version)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;       # Stable driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;         # Beta driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;   # Production driver (default, installs 550)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;  # Vulkan beta driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;   # Legacy driver (470 series)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;   # Legacy driver (390 series)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;   # Legacy driver (340 series)
}
