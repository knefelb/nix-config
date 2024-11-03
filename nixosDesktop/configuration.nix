# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  #begin Nvidia Config
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
   ##nvidia Config End---------

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixosDesktop"; # Define your hostname.
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

  ## Ollama
  #services.ollama = {
    ##package = pkgs.unstable.ollama; # Uncomment if you want to use the unstable channel, see https://fictionbecomesfact.com/nixos-unstable-channel
    #enable = true;
    #acceleration = "cuda"; # Or "rocm"
    ##environmentVariables = { # I haven't been able to get this to work myself yet, but I'm sharing it for the sake of completeness
      ## HOME = "/home/ollama";
      ## OLLAMA_MODELS = "/home/ollama/models";
      ## OLLAMA_HOST = "0.0.0.0:11434"; # Make Ollama accesible outside of localhost
      ## OLLAMA_ORIGINS = "http://localhost:8080,http://192.168.0.10:*"; # Allow access, otherwise Ollama returns 403 forbidden due to CORS
    ##};
  #};
  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
     pkgs.nextcloud-client
     terminator
     # vimplugin-vim-terminator
     pkgs.gnome-tweaks
     pkgs.gnome.gnome-boxes
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
     # Ollama related package below
     pkgs.oterm
     pkgs.llama-cpp
     pkgs.ollama
     
     pkgs.chromium
     pkgs.flameshot
     pkgs.python3
     #pkgs.mullvad
     #pkgs.mullvad-browser
     pkgs.qbittorrent
     pkgs.jellyfin
     pkgs.jellyfin-web
     pkgs.jellyfin-ffmpeg
     pkgs.vlc
     pkgs.virt-manager
     pkgs.libvirt
     pkgs.qemu
     pkgs.gnomeExtensions.openweather-refined

     #RDP session package
     pkgs.gnome.gnome-session

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.steam.enable = true
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # To Enable Steam Games
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
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
 