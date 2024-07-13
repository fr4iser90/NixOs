 {
  # Setup Configuration
  setup = "gaming"; # Options: "gaming", "multimedia", "server", "serverRemoteDesktop", "workspace", "custom"

  # User Configuration
  mainUser = "fr4iser";
  guestUser = "botchi";

  # HostName Configuration "${mainUser}-${setup}"; "testuser-desktop-gaming" needed for nixos-rebuild switch --flake .#testuser-desktop-gaming --show-trace
  hostName = "fr4iser-Lappy";

  # Desktop Environment Configuration
  desktop = "plasma"; # Options: "gnome", "plasma", "xfce"
  displayManager = "sddm"; # Options: "sddm", "lightdm", "gdm"
  session = "plasma"; # Options: "plasma", "plasmawayland"
  autoLogin = true; # Options: true, false

  # Hardware Configuration
  gpu = "amdgpu";
  inputDevices = "libinput"; # Options: "libinput", "evdev", "synaptics"

  # Audio Configuration
  audio = "pipewire"; # Options: "pulseaudio", "pipewire"

  # Network Configuration
  networkManager = "networkmanager"; # Options: "networkmanager", "wicd"

  # System Configuration
  timeZone = "Europe/Berlin"; # Insert timezone
  locales = [ "de_DE.UTF-8" ]; # List of locales "en_US.UTF-8"/"de_DE.UTF-8" etc.

  # Feature Toggles
  enableSSH = true; # Options: true, false
  enableRemoteDesktop = true; # Options: true, false (actually using sunshine(server) only, maybe implementing more; clients need moonlight)
  enableSteam = true;
  enableLutris = true;
  enableWine = true;
  enableFirewall = false; # Options: true, false
  enablePrinting = false; # Options: true, false
  enableBluetooth = false; # Options: true, false
  enableBackup = false; # Options: true, false
  securityHardening = false; # Options: true, false

  # Virtualization Options
  enableVirtualization = true; # Options: true, false | see virtualization-list for more
  # Backup Configuration
  backupDestination = "/mnt/backup"; # Backup destination path

  # Default Applications
  defaultBrowser = "firefox"; # Options: "firefox", "chromium", "brave", "vivaldi", "opera"

  # Additional Sources
 # additionalSources = [ "https://github.com/nix-community/home-manager" ]; # List of additional sources
}
