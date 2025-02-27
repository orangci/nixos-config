{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us,ro";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [pkgs.epson-escpr2];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Install Flatpak
    flatpak.enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Configure nvidia stuff
  hardware.nvidia.open = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethan = {
    isNormalUser = true;
    description = "Ethan";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd.enable = true;
  };

  programs = {
    # Install firefox.
    firefox.enable = true;
    # Install virt-manager
    virt-manager.enable = true;
    # Install zsh
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    # Install 1Password
    _1password.enable = true;
    _1password-gui = {
      enable = true;
    };
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    starship.enable = true;
    hyprland.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    tmux = {
      enable = true;
      clock24 = true;
    };
  };

  # Enable Nix-gaming
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable OpenRazer
  hardware.openrazer.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
    pkgs.git
    pkgs.neofetch
    pkgs.fastfetch
    pkgs.nitch
    pkgs.flatpak
    pkgs.alacritty
    pkgs.vscode
    pkgs.flameshot
    pkgs.vlc
    pkgs.spotify
    pkgs.vesktop
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    inputs.nix-gaming.packages.${pkgs.system}.osu-stable

    pkgs.libreoffice-qt
    pkgs.hunspell
    pkgs.hunspellDicts.uk_UA
    pkgs.hunspellDicts.th_TH

    pkgs.whatsapp-for-linux
    pkgs.chromium
    pkgs.epson-escpr2
    pkgs.zsh
    pkgs.tree
    pkgs.nerdfonts
    pkgs.starship
    pkgs.yt-dlp
    pkgs.unzip
    pkgs.konsave
    pkgs.audacity
    pkgs.element-desktop
    pkgs.dig

    # Hopefully it will work for lazyvim
    pkgs.clang-tools
    pkgs.cmake
    pkgs.codespell
    pkgs.conan
    pkgs.cppcheck
    pkgs.doxygen
    pkgs.gtest
    pkgs.lcov
    pkgs.vcpkg
    pkgs.vcpkg-tool
    pkgs.gcc

    pkgs.gh
    pkgs.nodejs
    pkgs.ookla-speedtest
    pkgs.kitty
    davinci-resolve
    pkgs.lutris
    pkgs.nodejs_23
    pkgs.distrobox
    pkgs.openrazer-daemon
    pkgs.btop
    pkgs.termius
    pkgs.lunar-client

    pkgs.wl-clipboard
    pkgs.hyprpanel
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
