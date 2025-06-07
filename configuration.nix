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

    # Load additional drivers for certain vendors (I.E: Wacom, Intel, etc.)
    initrd.unl0kr.allowVendorDrivers = true;
  };

  networking = {
    # Define your hostname.
    hostName = "e14";

    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    dhcpcd.enable = false;
    useNetworkd = true;
    # Wireless daemon.
    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        Settings = {
          AutoConnect = false;
        };
      };
    };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Define a user account for Home Manager.
  home-manager.backupFileExtension = "backup";
  home-manager.users.user = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];

    # User configurations below.
    # Bash scripts.
    programs.bash = {
      enable = true;
      profileExtra = ''
        clear > /dev/null 2>&1
        exec &> /dev/null
        if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';
    };

    # Bash theme.
    programs.oh-my-posh = {
      enable = true;
      useTheme = "clean-detailed";
    };

    # Hyprland.
    services.hyprpolkitagent.enable = true;

    # Lock screen utility.
    programs.hyprlock = {
      enable = true;
      settings = {
      };
    };

    # Idle daemon.
    # for more configuration options, refer https://wiki.hyprland.org/Hypr-Ecosystem/hypridle
    services.hypridle = {
      enable = true;
      settings = {
        general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 150                                # 2.5min.
            on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = brightnessctl -r                 # monitor backlight restore.
          }

          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 150                                          # 2.5min.
            on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
            on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
          }

          {
            timeout = 300                                 # 5min.
            on-timeout = loginctl lock-session            # lock screen when timeout has passed.
          }

          {
            timeout = 330                                 # 5.5min.
            on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed.
            on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = 1800                                # 30min.
            on-timeout = systemctl suspend                # suspend pc.
          }
        ];
      };
    };

    # Walppaper.
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "/share/wallpapers/buttons.png" "/share/wallpapers/cat_pacman.png" ];

        wallpaper = [
          "eDP-1,/share/wallpapers/buttons.png"
          "HDMI-A-1,/share/wallpapers/cat_pacman.png"
        ];
      };
    };

    # Window Manager.
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
      };
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "25.05"; # Please read the comment before changing.
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  systemd.network.enable = true;
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
