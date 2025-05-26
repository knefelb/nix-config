# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{

  
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot 
  hardware.enableAllFirmware = true;
 

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
     
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages_5_15;

  networking.hostName = "nixosThinkCentre"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.wifi.powersave = false;  

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #Enable Gnome extenions and specify Openweattheer
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bear = {
    isNormalUser = true;
    description = "bear";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    # thunderbird
      # for virtualisation per user

    ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes and new command-line tool
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     git
     vim 
     wget
     curl
     pkgs.bitwarden
     pkgs.nextcloud-client
     terminator
     #RDP session package
     pkgs.gnome-session
     pkgs.gnome-tweaks
     pkgs.gnome-boxes
     pkgs.tor-browser
     pkgs.cherrytree
     pkgs.git
     pkgs.sparrow
     pkgs.spotify
     pkgs.btop
     pkgs.remmina
     pkgs.openvpn
     pkgs.vscode
     #pkgs.zsh
     pkgs.neofetch
     pkgs.neovim
     pkgs.starship
     pkgs.autojump
     pkgs.libreoffice
     pkgs.freetube 
     pkgs.chromium
     pkgs.flameshot
     pkgs.python3
     pkgs.librewolf
     pkgs.mullvad
     pkgs.mullvad-browser
     pkgs.qbittorrent
     pkgs.vlc
     pkgs.virt-manager
     pkgs.libvirt
     pkgs.gnomeExtensions.openweather-refined
     pkgs.sops
     pkgs.nfs-utils
     pkgs.simplex-chat-desktop
     pkgs.calibre
     pkgs.flatpak
     pkgs.protonvpn-gui
  ];

  programs.chromium = {
  enable = true;
  extensions = [
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    "iokeahhehimjnekafflcihljlcjccdbe" # Alby Wallet
  ];
  };
  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  #Fix for firefox crashing

  environment.variables = {
    MOZ_ENABLE_WAYLAND = 0;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.steam.enable = true
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ############
  ##Services##
  ############

  #Firmware update service 
  services.fwupd.enable = true;

  #enable Flatpak service
  services.flatpak.enable = true;  

  # xRDP SEssion Gnome enable
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable tor  
    services.tor.client.enable = true;
  # Enable Mullvad service
    # services.mullvad-vpn.enable = true;

  # Virt-Manager service
  # Enable the libvirt daemon for managing virtual machines
  virtualisation.libvirtd.enable = true;

  # Optional: Enable virt-manager for managing VMs with a GUI
  programs.virt-manager.enable = true;
  
  # Optimise the store. this enables periodic optimisation  
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

  # Automatic Garbage collection
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 14d";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 40999 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on ).
  system.stateVersion = "24.11"; # Did you read the comment?
}
 
