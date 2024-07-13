{
  mainUser
}:

{
  setups = {
    desktop-gaming = {
      hostName = "${mainUser}-gaming";
    };
    desktop-headless = {
      hostName = "${mainUser}-headless";
    };
    laptop-gaming = {
      hostName = "${mainUser}-laptopgaming";
    };
    tty-server = {
      hostName = "${mainUser}-tty";
    };
  };
}
