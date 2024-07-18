{
  setup = "server";
  mainUser = "ServerOne";
  guestUser = "";
  hostName = "ServerOne";
  timeZone = "Europe/Berlin";
  locales = [ "de_DE.UTF-8" ];
  keyboardLayout = "de";
  keyboardOptions = "eurosign:e";
  enableSSH = true;
  enableRemoteDesktop = false;
  enableSteam = false;
  enableVirtualization = true;
  enableFirewall = true;
  enablePrinting = false;
  enableBluetooth = false;
  enableBackup = true;
  securityHardening = true;
  defaultShell = "zsh";
  enableBash = true; 
  enableZsh = true;  
  enableFish = true;  
  enableTcsh = false;  
  enableDash = false;  
  enableKsh = false;  
  enableMksh = false;  
  enableXonsh = false;
  defaultBrowser = "firefox";
  audio = "pipewire";
  gpu = "amdgpu";
  inputDevices = "libinput";
  networkManager = "networkmanager";
  backupDestination = "/mnt/backup";
}
