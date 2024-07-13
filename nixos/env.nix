{
  setup = "custom";
  mainUser = "fr4iser";
  guestUser = "";
  hostName = "fr4iser";
  desktop = "plasma";
  displayManager = "sddm";
  autoLogin = true;
  timeZone = "Europe/Berlin";
  locales = [ "de_DE.UTF-8" ];
  keyboardLayout = "de";
  enableSSH = false;
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
  gpu = "intel";
  inputDevices = "libinput";
  networkManager = "networkmanager";
  backupDestination = "/mnt/backup";
}
