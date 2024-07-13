{
  # Setup Configuration
  setup = "desktop-gaming"; # Options: "desktop-gaming", "desktop-headless", "laptop-gaming", "tty-server"

  # User Configuration
  mainUser = "fr4iser";
  guestUser = "botchi";

  # Desktop Environment Configuration
  desktop = "plasma"; # Options: "gnome", "plasma", "xfce"
  displayManager = "sddm"; # Options: "sddm", "lightdm", "gdm"
  displayServer = "wayland"; # Options: "x11", "wayland", "both"

  # Hardware Configuration
  gpu = "amdgpu"; # Options: "amdgpu", "nvidia"
  inputDevices = "libinput"; # Options: "libinput", "evdev", "synaptics"

  # Audio Configuration
  audio = "pipewire"; # Options: "pulseaudio", "pipewire"

  # Network Configuration
  networkManager = "networkmanager"; # Options: "networkmanager", "wicd"

  # Miscellaneous Tools and Services
  miscTools = [ "htop" "curl" ]; # List of additional miscellaneous tools
  services = [ "sshd" ]; # Additional services

  # System Configuration
  timeZone = "Europe/Berlin";
  locales = [ "en_US.UTF-8" "de_DE.UTF-8" ]; # List of locales
  openPorts = [ 80 443 ]; # List of ports to open

  # Feature Toggles
  enableSSH = true; # Options: true, false
  enableFirewall = true; # Options: true, false
  enablePrinting = true; # Options: true, false
  enableBluetooth = true; # Options: true, false
  enableVirtualization = true; # Options: true, false | see virtualization-list for more
  laptopMode = true; # Options: true, false
  enableBackup = false; # Options: true, false
  securityHardening = true; # Options: true, false

  # Virtualization Options
  virtualization = {
    docker = true;       # Docker containerization
    podman = false;      # Podman containerization
    kvm = false;         # KVM virtualization
    qemu = false;        # QEMU virtualization
    virtualbox = false;  # VirtualBox virtualization
    lxc = false;         # LXC containers
    firecracker = false; # Firecracker microVMs
  };

  # Backup Configuration
  backupDestination = "/mnt/backup"; # Backup destination path

  # Default Applications
  defaultBrowser = "firefox"; # Options: "firefox", "chromium", "brave", "vivaldi", "opera"

  # Additional Sources
  additionalSources = [ "https://github.com/nix-community/home-manager" ]; # List of additional sources

  # Import setups from setups/index.nix
  inherit (import ./setups { inherit mainUser setup; }) setups currentSetup hostName;
}
