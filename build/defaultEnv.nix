{
  setup = "laptop-gaming";
  mainUser = "";
  guestUser = "";
  hostName = "";
  desktop = "plasma";
  displayManager = "sddm";
  session = "plasma";
  autoLogin = true;
  timeZone = "Europe/Berlin";
  locales = [ "de_DE.UTF-8" ];
  keyboardLayout = "de";
  enableSSH = false;
  enableRemoteDesktop = false;
  enableSteam = false;
  enableVirtualization = false;
  enableFirewall = false;
  enablePrinting = false;
  enableBluetooth = false;
  enableBackup = false;
  securityHardening = false;
  defaultBrowser = "firefox";
  audio = "pipewire";
  gpu = "nvidiaIntelPrime";
  inputDevices = "libinput";
  networkManager = "networkmanager";
  backupDestination = "/mnt/backup";
}
