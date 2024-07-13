{
  setup = "workspace";
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
  enableSSH = true;
  enableRemoteDesktop = false;
  enableSteam = true;
  enableVirtualization = false;
  enableFirewall = false;
  enablePrinting = false;
  enableBluetooth = false;
  enableBackup = false;
  securityHardening = false;
  defaultBrowser = "firefox";
  audio = "pipewire";
  gpu = "check";
  inputDevices = "libinput";
  networkManager = "networkmanager";
  backupDestination = "/mnt/backup";
}
