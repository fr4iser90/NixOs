{
  # System Setup
  setup = "laptop-gaming";
  hostName = "";
  domain = "";
  timeZone = "Europe/Berlin";
  locales = [ "de_DE.UTF-8" ];

  # Users
  mainUser = "";
  guestUser = "";
  autoLogin = true;

  # Desktop Environment
  desktop = "plasma";
  displayManager = "sddm";
  session = "plasma";
  keyboardLayout = "de";
  keyboardOptions = "eurosign:e";
  darkMode = true; # Options: true, false


  # Network
  networkManager = "networkmanager";
  enableSSH = false;
  enableRemoteDesktop = false;

  # Software
  defaultBrowser = "firefox";
  audio = "pipewire";
  gpu = "nvidiaIntelPrime";
  inputDevices = "libinput";

  # Optional Features
  enableSteam = false;
  enableVirtualization = false;
  enableFirewall = false;
  enablePrinting = false;
  enableBluetooth = false;
  enableBackup = false;

  # Shells
  defaultShell = "fish";
  enableBash = true;
  enableZsh = false;
  enableFish = true;
  enableTcsh = false;
  enableDash = false;
  enableKsh = false;
  enableMksh = false;
  enableXonsh = false;

  # Security
  securityHardening = false;

  # Backup
  backupDestination = "/mnt/backup";
}
