{
  # Setup Configuration
  setup = "gaming"; # Options: "gaming", "workspace", "multimedia", "server", "serverHeadless"

  # User Configuration
  mainUser = "";
  guestUser = "";

  # HostName Configuration "${mainUser}-${setup}"; "testuser-desktop-gaming" needed for nixos-rebuild switch --flake .#testuser-desktop-gaming --show-trace
  hostName = "";

  # Desktop Environment Configuration
  desktop = "plasma"; # Options: "gnome", "plasma", "xfce"
  displayManager = "sddm"; # Options: "sddm", "lightdm", "gdm"
  session = "plasma"; # Options: "plasma", "plasmawayland"
  autoLogin = true; # Options: true, false

  # System Configuration
  timeZone = "Europe/Berlin"; # Insert timezone
  locales = [ "de_DE.UTF-8" ]; # List of locales "en_US.UTF-8"/"de_DE.UTF-8" etc.
  keyboardLayout = "de"; # List of layouts: "us", "uk", "fr", "es", "it", "jp", "ru", "zh", "kr", "br"

  # Feature Toggles
  enableSSH = false; # Options: true, false
  enableRemoteDesktop = false; # Options: true, false (actually using sunshine(server) only, maybe implementing more; clients need moonlight)
  enableSteam = false;
  enableVirtualization = false; # Options: true, false | see virtualization-list for more
  enableFirewall = false; # Options: true, false
  enablePrinting = false; # Options: true, false
  enableBluetooth = false; # Options: true, false
  enableBackup = false; # Options: true, false
  securityHardening = false; # Options: true, false


  # Default Applications
  defaultBrowser = "firefox"; # Options: "firefox", "chromium", "brave", "vivaldi", "opera"

  # Audio Configuration
  audio = "pipewire"; # Options: "pulseaudio", "pipewire"

  # Hardware Configuration
  gpu = "nvidiaIntelPrime"; # Options: "amdgpu", "nvidia", "nvidiaIntelPrime" "intel"
  inputDevices = "libinput"; # Options: "libinput", "evdev", "synaptics"

  # Network Configuration
  networkManager = "networkmanager"; # Options: "networkmanager", "wicd"

  # Backup Configuration
  backupDestination = "/mnt/backup"; # Backup destination path
}
