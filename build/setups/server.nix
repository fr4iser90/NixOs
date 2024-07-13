{
  setup = "server";
  mainUser = "";
  guestUser = "";
  hostName = "";
  timeZone = "Europe/Berlin";
  locales = [ "de_DE.UTF-8" ];
  keyboardLayout = "de";
  enableSSH = true;
  enableRemoteDesktop = false;
  enableSteam = false;
  enableVirtualization = true;
  enableFirewall = true;
  enablePrinting = false;
  enableBluetooth = false;
  enableBackup = true;
  securityHardening = true;
  defaultBrowser = "firefox";
  audio = "pipewire";
  gpu = "amdgpu";
  inputDevices = "libinput";
  networkManager = "networkmanager";
  backupDestination = "/mnt/backup";
}
