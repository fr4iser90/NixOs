# NixOS Configurations

This project provides a set of preconfigured modules for NixOS, aimed at setting up various environments such as gaming, workspace, server remote desktop, and general server setups. The goal is to simplify and automate the configuration of NixOS systems.

## Features

- **Gaming Setup**: Install and configure gaming-related software and settings.
- **Workspace Setup**: Prepare a productive workspace environment.
- **Server Remote Desktop**: Configure a server for remote desktop access.
- **General Server Setup**: Set up a basic server configuration.
- **Modular Design**: Easily extendable to include more modules as needed.

## Prerequisites

Before running the build script, the script will check and install the necessary programs on your system if they are not already installed. These include:

- `fzf`
- `mkpasswd`
- `pciutils`
- Any other dependencies listed in the respective module files

## Installation

To install and use these configurations, follow these steps:

1. Clone the repository:

    ```sh
    git clone https://github.com/fr4iser90/NixOs.git
    cd NixOs
    ```

2. Make the main build script executable:

    ```sh
    chmod +x build.sh
    ```

3. Run the build script to install the desired configuration modules:

    ```sh
    bash ./build.sh
    ```

The `build.sh` script will guide you through a menu where you can select and install the predefined modules you need for your NixOS configuration.

## Usage

### Gaming Setup
File: `/etc/nixos/modules/packages/setup/gaming.nix`

Includes:

- `lsof`
- `git`
- `wget`
- `tree`
- `firefox`
- `vlc`
- `fish`
- `alacritty`
- `lutris`
- `wine`
- `winetricks`
- `wineWowPackages.full`
- `discord`
- `bitwarden-cli`
- `owncloud-client`
- `plex`
- `ffmpeg`

### Multimedia Setup
File: `/etc/nixos/modules/packages/setup/multimedia.nix`

Includes:

- `lsof`
- `git`
- `wget`
- `tree`
- `firefox`
- `vlc`
- `fish`
- `alacritty`
- `plex`
- `kodi`
- `rhythmbox`
- `clementine`
- `spotify`

### General Server Setup
File: `/etc/nixos/modules/packages/setup/server.nix`

Includes:

- `lsof`
- `git`
- `wget`
- `tree`
- `konsole`
- `htop`
- `tmux`
- `screen`
- `nmap`
- `ncdu`
- `iperf3`
- `ethtool`
- `openssh`
- ...

### Server Remote Desktop Setup
File: `/etc/nixos/modules/packages/setup/serverRemoteDesktop.nix`

Includes:

- `lsof`
- `git`
- `wget`
- `tree`
- `konsole`
- `htop`
- `tmux`
- `screen`
- `nettools`
- `nmap`
- `ncdu`
- `iperf3`
- `ethtool`
- `openssh`
- `fail2ban`
- `iptables`
- `tcpdump`
- `rsync`
- `curl`
- `firefox`
- `vlc`
- `weston`
- `x11vnc`
- ...

### Workspace Setup
File: `/etc/nixos/modules/packages/setup/workspace.nix`

Includes:

- `discord`
- `lsof`
- `git`
- `wget`
- `tree`
- `firefox`
- `vlc`
- `fish`
- `alacritty`
- `vscode`
- `clion`
- `qtcreator`
- `geany`
- `eclipse`
- `monodevelop`
- `android-studio`
- ...

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contact

If you have any questions or issues, feel free to open an issue on GitHub or contact the repository owner.

## Screenshots/Demo

A screenshot demonstrating the gaming setup module.

---

Happy Nixing!
