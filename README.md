NixOs Configurations
Overview

This project provides a set of preconfigured modules for NixOS, aimed at setting up various environments such as gaming, workspace, server remote desktop, and general server setups. The goal is to simplify and automate the configuration of NixOS systems.
Features

    Gaming Setup: Install and configure gaming-related software and settings.
    Workspace Setup: Prepare a productive workspace environment.
    Server Remote Desktop: Configure a server for remote desktop access.
    General Server Setup: Set up a basic server configuration.
    Modular Design: Easily extendable to include more modules as needed.

Prerequisites

Before running the build script, ensure you have the necessary programs installed on your system. These include:

    nix
    git
    Any other dependencies listed in the respective module files

Installation

To install and use these configurations, follow these steps:

    Clone the repository:

    sh

git clone https://github.com/fr4iser90/NixOs.git
cd NixOs

Make the main build script executable:

chmod +x build.sh

Run the build script to install the desired configuration modules
sh

    ./build.sh


   bash ./build.sh

The build.sh script will automatically execute the necessary scripts to set up your NixOS configuration based on the selected modules.
Usage

Here are some examples of how to use the different configuration modules:
Gaming Setup


License

This project is licensed under the MIT License. See the LICENSE file for details.
Contact

If you have any questions or issues, feel free to open an issue on GitHub or contact the repository owner.
Screenshots/Demo


A screenshot demonstrating the gaming setup module.
