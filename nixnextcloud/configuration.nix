# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "NextCloudNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bear = {
    isNormalUser = true;
    description = "bear";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
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
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl
     pkgs.bitwarden
     terminator
     pkgs.gnome-tweaks
     pkgs.gnome-boxes
     pkgs.cherrytree
     pkgs.git
     pkgs.btop
     pkgs.neofetch
     pkgs.neovim
     pkgs.starship
     pkgs.autojump
     pkgs.chromium
     pkgs.libvirt
     pkgs.vscode
     pkgs.qemu
     #RDP session package
     pkgs.gnome-session

     pkgs.nfs-utils

 ];

  programs.chromium = {
  enable = true;
  extensions = [
    "nngceckbapebfimnlniiiahkandclblb" # ublock origin
  ];
  };
  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  #Fix for firefox crashing

  environment.variables = {
    MOZ_ENABLE_WAYLAND = 0;
  };

 
   # xRDP SEssion Gnome enable
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Nextcloud setup
  
  
  environment.etc."nextcloud-admin-pass".text = "Cranberry!Overrule!";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "nextcloudnix.com";
    # configureRedis = true;
    # https = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.adminuser = "bear";
    config.dbtype = "pgsql";
    extraOptions = {
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
    };
    autoUpdateApps.enable = true;
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar contacts mail notes tasks whiteboard;
    };
    
   };

  # Virt-Manager service
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  # Optimise the store. this enables periodic optimisation  
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

  # Automatic Garbage collection
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
}
 
