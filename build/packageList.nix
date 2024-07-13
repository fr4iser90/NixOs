{
  common = [
    lsof               # Lists open files.
    git                # Version control system.
    wget               # Network downloader.
    tree               # Display directories as trees.
    bitwarden-desktop  # Desktop application for Bitwarden, a password manager.
    corefonts          # Microsoft TrueType core fonts.
  ];
  
  communication = [
    discord               # Voice, video, and text communication application.
    slack                 # Collaboration and messaging app for teams.
    skypeforlinux         # Skype client for Linux.
    signal-desktop        # Signal Private Messenger desktop client.
    telegram-desktop      # Telegram desktop client.
    zoom-us               # Video conferencing software.
    mattermost-desktop    # Desktop client for Mattermost, an open-source messaging platform.
    hexchat               # IRC client.
    weechat               # Terminal-based IRC client.
    pidgin                # Universal chat client.
    wire-desktop          # Wire secure messaging and collaboration.
    thunderbird           # Email client with support for chat and newsgroups.
    element-desktop       # Matrix client for secure communication.
  ];

  development = [
    vscode             # Visual Studio Code, a code editor.
    kate               # Advanced text editor.
    emacs              # Extensible, customizable text editor.
    vim                # Highly configurable text editor.
    neovim             # Hyperextensible Vim-based text editor.
    sublime-text       # Sophisticated text editor for code, markup, and prose.
    atom               # Hackable text editor for the 21st century.
    intellij-idea-community # IntelliJ IDEA Community Edition, a powerful Java IDE.
    pycharm-community  # PyCharm Community Edition, a Python IDE.
    clion              # Cross-platform IDE for C and C++ by JetBrains.
    qtcreator          # Cross-platform IDE tailored to the needs of Qt developers.
    geany              # Lightweight IDE.
    eclipse            # IDE for Java development.
    monodevelop        # IDE for .NET and C# development.
    android-studio     # Android development environment.
    gitkraken          # Cross-platform Git GUI.
    postman            # API development environment.
    docker             # Platform for developing, shipping, and running applications.
    kubectl            # Command-line tool for controlling Kubernetes clusters.
    terraform          # Infrastructure as code software tool.
    ansible            # Automation tool for IT tasks.
    chefdk             # Development kit for Chef, a configuration management tool.
    vagrant            # Tool for building and managing virtualized development environments.
    heroku-cli         # Command-line interface for Heroku.
    awscli             # Command-line interface for Amazon Web Services.
    azure-cli          # Command-line interface for Microsoft Azure.
    gdb                # GNU Debugger.
    cmake              # Cross-platform build-system generator.
    make               # Build automation tool.
    bazel              # Build and test tool that scales to very large codebases.
    maven              # Build automation tool used primarily for Java projects.
    gradle             # Build automation tool for multi-language software development.
    nodejs             # JavaScript runtime built on Chrome's V8 JavaScript engine.
    npm                # Package manager for JavaScript.
    yarn               # JavaScript package manager alternative to npm.
    python3            # Python programming language, version 3.
    ruby               # Ruby programming language.
    go                 # Go programming language.
    rustup             # Rust toolchain installer.
    php                # PHP programming language.
    perl               # Perl programming language.
    elixir             # Elixir programming language.
    haskell.compiler.ghc8104 # Glasgow Haskell Compiler.
    racket             # General-purpose programming language in the Lisp-Scheme family.
    julia              # High-performance programming language for technical computing.
    sbcl               # Steel Bank Common Lisp, a Common Lisp implementation.
    lua                # Lightweight scripting language.
  ];

  gaming = [
    lutris                  # Open gaming platform.
    wine                    # Compatibility layer for running Windows applications.
    wineWowPackages.full    # Full set of 32-bit and 64-bit Wine packages.
    winetricks              # Utility for Wine to manage software installation.
    steam                   # Steam gaming platform. use steamenable instead
    playonlinux             # Frontend for Wine.
    dosbox                  # x86 emulator with DOS.
    scummvm                 # Emulator for classic adventure games.
    retroarch               # Frontend for emulators, game engines, and media players.
    mame                    # Multiple Arcade Machine Emulator.
    pcsx2                   # PlayStation 2 emulator.
    dolphin                 # GameCube and Wii emulator.
    yuzu                    # Nintendo Switch emulator.
    rpcs3                   # PlayStation 3 emulator.
    ppsspp                  # PSP emulator.
    mednafen                # Multi-system emulator.
    openmsx                 # MSX emulator.
    visualboyadvance-m      # Game Boy Advance emulator.
    nestopia                # NES/Famicom emulator.
    mgba                    # Game Boy Advance emulator.
    libretro                # Collection of emulators and game engines.
    itch-setup              # Client for itch.io, an open marketplace for indie games.
  ];

  multimedia = [
    pavucontrol        # PulseAudio volume control.
    vlc                # Versatile media player.
    mpv                # Media player based on MPlayer and mplayer2.
    ffmpeg             # Complete, cross-platform solution to record, convert and stream audio and video.
    handbrake          # Open-source video transcoder.
    audacity           # Free, open source, cross-platform audio software.
    kdenlive           # Free and open-source video editor.
    blender            # Open-source 3D creation suite.
    gimp               # GNU Image Manipulation Program.
    inkscape           # Open-source vector graphics editor.
    obs-studio         # Software for live streaming and screen recording.
    cheese             # Webcam application for recording and taking photos.
    shotwell           # Photo manager for GNOME.
    darktable          # Open-source photography workflow application and raw developer.
    rawtherapee        # Cross-platform raw image processing program.
    rhythmbox          # Music playing application for GNOME.
    clementine         # Modern music player and library organizer.
    spotify            # Digital music service.
    kodi               # Open-source home theater software.
    plex-media-server  # Media server for managing and streaming your digital media.
    mediainfo          # Tool for displaying technical information about media files.
    sox                # Command-line utility that can convert various formats of computer audio files.
    flac               # Free Lossless Audio Codec.
    opus-tools         # Utilities to encode, inspect, and decode .opus files.
    soundconverter     # GNOME application to convert audio files.
    simplescreenrecorder # Screen recorder for Linux.
    vokoscreenNG       # Easy to use screencast creator.
    picard             # MusicBrainz Picard, a cross-platform music tagger.
    gnome-sound-recorder # Simple sound recorder for GNOME.
    brasero            # CD/DVD mastering tool for GNOME.
    mkvtoolnix         # Set of tools to create, alter, and inspect Matroska files.
  ];

  shellAndTerminals = [
    fish                # Friendly interactive shell.
    alacritty           # GPU-accelerated terminal emulator.
    kitty               # Fast, feature-rich, GPU-based terminal emulator.
    zsh                 # Highly customizable interactive shell.
    bash                # GNU Bourne Again Shell.
    tmux                # Terminal multiplexer.
    screen              # Terminal multiplexer.
    terminator          # Terminal emulator with multiple terminals in one window.
    tilix               # Tiling terminal emulator for GNOME.
    xfce4-terminal      # Terminal emulator for the Xfce desktop environment.
    gnome-terminal      # Terminal emulator for the GNOME desktop environment.
    konsole             # Terminal emulator for the KDE desktop environment.
    rxvt-unicode        # Highly customizable terminal emulator.
    guake               # Drop-down terminal for GNOME.
    yakuake             # Drop-down terminal for KDE.
  ];

  systemUtilities = [
    samba            # SMB/CIFS file, print, and login server.
    sambaFull        # Full version of Samba.
    libnotify        # Desktop notification library.
    yad              # Yet another dialog, a user dialog tool.
    nss              # Network Security Services libraries.
    liburing         # Library for Linux native I/O.
    lshw             # Hardware lister.
    ethtool          # Utility for examining and tuning network interfaces.
    htop             # Interactive process viewer.
    neofetch         # System information tool.
    ranger           # Console file manager with VI key bindings.
    mc               # Midnight Commander, a visual file manager.
    lf               # Terminal file manager written in Go.
    fd               # Simple, fast, and user-friendly alternative to `find`.
    bat              # Cat clone with syntax highlighting and Git integration.
    fzf              # Command-line fuzzy finder.
    ripgrep          # Line-oriented search tool.
    exa              # Modern replacement for `ls`.
    duf              # Disk usage utility with a user-friendly interface.
    ncdu             # Disk usage analyzer with an ncurses interface.
  ];

  browsers = [
    brave                # Privacy-focused web browser.
    firefox              # Popular open-source web browser.
    google-chrome        # Google's proprietary web browser.
    chromium             # Open-source version of Google Chrome.
    vivaldi              # Web browser developed by Vivaldi Technologies.
    opera                # Web browser developed by Opera Software.
    qutebrowser          # Keyboard-focused browser with a minimal GUI.
    midori               # Lightweight, fast web browser.
    falkon               # KDE web browser using QtWebEngine.
    epiphany             # GNOME web browser (also known as GNOME Web).
    elinks               # Text-based web browser.
    w3m                  # Text-based web browser with support for images.
    luakit               # Fast, lightweight web browser following the UNIX philosophy.
    otter-browser        # Web browser aiming to recreate the best aspects of Opera 12.
  ];

    virtualization = [
    docker               # Docker containerization
    podman               # Podman containerization
    kvm                  # KVM virtualization
    qemu                 # QEMU virtualization
    virtualbox           # VirtualBox virtualization
    lxc                  # LXC containers
    firecracker          # Firecracker microVMs
  ];

  serverPackages = [
    openssh            # Secure Shell (SSH) protocol suite for remote login and other secure network services.
    nginx              # High-performance HTTP server and reverse proxy.
    apacheHttpd         # The Apache HTTP Server.
    mariadb            # A community-developed, commercially supported fork of the MySQL relational database management system (RDBMS).
    postgresql         # A powerful, open source object-relational database system.
    redis              # In-memory data structure store, used as a distributed, in-memory key–value database, cache and message broker.
    memcached          # High-performance, distributed memory object caching system.
    bind               # An implementation of the Domain Name System (DNS) protocols.
    postfix            # A free and open-source mail transfer agent (MTA) that routes and delivers electronic mail.
    dovecot            # An open-source IMAP and POP3 server for Unix-like operating systems.
    fail2ban           # An intrusion prevention software framework that protects computer servers from brute-force attacks.
    iptables           # Administration tool for IPv4 packet filtering and NAT.
    nftables           # The packet filtering and classification framework in the Linux kernel.
    tcpdump            # A powerful command-line packet analyzer.
    prometheus         # An open-source systems monitoring and alerting toolkit.
    grafana            # A multi-platform open-source analytics and interactive visualization web application.
    nodeExporter       # Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go.
    docker             # Platform for developing, shipping, and running applications.
    podman             # An open-source container management tool.
    kubernetes         # Production-Grade Container Orchestration.
    ansible            # Automation tool for IT tasks.
    salt               # Infrastructure automation and management software.
    terraform          # Infrastructure as code software tool.
    vault              # A tool for managing secrets.
    consul             # A tool for service discovery, monitoring and configuration.
    nomad              # A workload orchestrator.
    packer             # A tool for creating identical machine images for multiple platforms.
    wireguard          # An extremely simple yet fast and modern VPN.
    openvpn            # An open source software application that implements virtual private network (VPN) techniques for creating secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities.
    traefik            # Moderner HTTP-Router und Reverse-Proxy, der für Microservices-Infrastrukturen optimiert ist.
  ];
}
