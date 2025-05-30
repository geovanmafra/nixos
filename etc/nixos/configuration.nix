# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "e14"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Enable programs as services.
  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;
  programs.waybar.enable = true;
  # GTK
  programs.dconf.enable = true;
  programs.nm-applet.enable = true;
  programs.gnome-disks.enable = true;
  # Appimage support.
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  # Browser.
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [ uget-integrator ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # TTY
    micro # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ghostty
    btop
    fastfetch
    # Utilities
    wget
    git
    unrar
    uget # Download Manager.
    wl-clipboard
    grim # Screenshots.
    slurp # Screenshots.
    mako # Notifications daemon.
    wofi # Application Launcher.
    xdg-user-dirs # Home Folder Management.
    qview # Image Viewer.
    mpv # Video Player.
    jdk # Java 21 for Minecraft.
    # Hyprland
    hyprpolkitagent
    hyprland-protocols
    hyprland-qt-support
    hyprland-qtutils
    hyprcursor
    hyprpicker
    hyprpaper
    # Waybar
    brightnessctl
    playerctl
    # Applets
    pwvucontrol
    # GTK
    adwaita-icon-theme
    gtk-engine-murrine # Theme Engine.
    zenity # Dialog Box.
    nautilus # File Manager.
    file-roller # Archive Manager.
    # Gaming
    bottles
    ares
    mednaffe
    duckstation
    pcsx2
    rpcs3
    ppsspp-qt
    dolphin-emu
    cemu
    azahar
    # Daily
    keepassxc
    discord
    krita
    krita-plugin-gmic
    obs-studio
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List services that you want to enable:
  services.getty.autologinUser = "user"; # TTY AL.
  services.openssh.enable = true; # Enable the OpenSSH daemon.
  services.udisks2.enable = true; # Automounting support.
  services.hypridle.enable = true;
  services.gvfs.enable = true; # Nautilus outside of Gnome.
  services.gnome.sushi.enable = true; # Quick previewer for nautilus.
  services.blueman.enable = true; # Bluetooth applet.
  hardware.bluetooth.enable = true; # Bluetooth support.

  # Enable fonts accessible to applications.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

