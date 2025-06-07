# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  # Import Home Manager without nix-channel.
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Introduce a new option called home-manager.users who maps the user to Home Manager configuration.
      "${home-manager}/nixos"
    ];

  boot = {
    # Use the latest kernel.
    kernelPackages = pkgs.linuxPackages_zen; # More options available at https://nixos.wiki/wiki/Linux_kernel.

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Enable quiet boot.
    loader.timeout = 0;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
    plymouth.enable = true;
  };

  networking = {
    # Define your hostname.
    hostName = "e14";

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    wireless.iwd.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Define a user account for Home Manager.
  home-manager.users.user = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];

    # User configurations below.
    programs.bash.enable = true;

    # This value determines the Home Manager release that your configuration is 
    # compatible with. This helps avoid breakage when a new Home Manager release 
    # introduces backwards incompatible changes. 
    #
    # You should not change this value, even if you update Home Manager. If you do 
    # want to update the value, then make sure to first check the Home Manager 
    # release notes. 
    home.stateVersion = "25.05"; # Please read the comment before changing. 
  };

  # Allow proprietary software.
  nixpkgs.config.allowUnfree = true;

  environment = {
    # Set environment variables.
    sessionVariables.NIXOS_OZONE_WL = "1";

    # List packages installed in system profile. You can use https://search.nixos.org/ to find more packages (and options).
    systemPackages = with pkgs; [
      # Terminal.
      micro # The Nano editor is also installed by default.
      ghostty
      neohtop # Resource monitor.
      impala # Wi-Fi manager.
      bluetui # Bluetooth manager.
      rmpc # Music player.
      fastfetch # System informations.

      # Utilities.
      wget
      git
      xz
      unrar
      ntfs3g
      uget
      ffmpegthumbnailer
      wl-clipboard
      grim
      slurp
      mako
      wofi
      qview
      xdg-user-dirs
      mpv

      # Hyprland.
      hyprpolkitagent
      hyprland-protocols
      hyprland-qt-support
      hyprland-qtutils
      hyprcursor
      hyprpicker
      hyprpaper

      # Waybar.
      waybar
      playerctl
      brightnessctl

      # GTK.
      gtk-engine-murrine
      gnome-themes-extra
      adwaita-icon-theme
      dconf-editor
      zenity
      file-roller
      gparted

      # Daily.
      keepassxc
      discord
      krita
      krita-plugin-gmic
      obs-studio

      # Gaming.
      bottles
      ares
      mednaffe
      # Sony.
      duckstation
      pcsx2
      rpcs3
      ppsspp-qt
      # Nintendo.
      dolphin-emu
      cemu
      azahar
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs = {
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  # List fonts accessible to applications.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome # For Waybar icons.
  ];

  # List services that you want to enable:
  services = {
    # Enable the X11 windowing system.
    # xserver.enable = true;

    # Configure keymap in X11
    # xserver.xkb.layout = "us";
    # xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable sound.
    # services.pulseaudio.enable = true;
    # OR
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  # List hardware services that you want to enable:
  # Bluetooth support.
  hardware.bluetooth.enable = true;

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
