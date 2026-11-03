{ pkgs, lib, host, ... }:
{
  home.username = host.username;
  home.homeDirectory = host.homeDirectory;
  home.stateVersion = "25.11";
  targets.genericLinux.enable = true;

  home.packages = import ./packages.nix pkgs ++ [
    pkgs.git-filter-repo
    pkgs.dfu-util
    pkgs.kanata
    pkgs.msitools
    pkgs.wl-clipboard
    pkgs.nerd-fonts.hack
    pkgs.zsh
    pkgs.nixgl.auto.nixGLDefault
  ];

  fonts.fontconfig.enable = true;

  dconf.settings = {
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position    = "BOTTOM";
      dock-fixed       = false;
      extend-height    = false;
      autohide         = true;
      autohide-in-fullscreen = true;
      intellihide      = true;
      require-pressure-to-show = false;
      show-delay       = (lib.hm.gvariant.mkDouble 0.0);
      animation-time   = (lib.hm.gvariant.mkDouble 0.1);
      dash-max-icon-size = 48;
      show-mounts      = false;
      show-trash       = false;
      show-show-apps-button = true;
      click-action     = "minimize";
      scroll-to-focused-application = true;
      running-indicator-style = "DOTS";
    };
    "org/gnome/desktop/interface" = {
      color-scheme     = "prefer-dark";  # Dark mode
      gtk-theme        = "Yaru-dark";
      icon-theme       = "Yaru";
      clock-show-weekday = true;
      show-battery-percentage = true;
      enable-animations = true;
      font-antialiasing = "rgba";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      repeat          = true;
      repeat-interval = 1;    # ms between repeats
      delay           = 100;  # ms before repeat starts
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click    = true;
      natural-scroll  = false;
      speed           = 0.5;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll  = false;
      accel-profile   = "default";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files     = false;
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = false;
    };
    "org/gnome/desktop/sound" = {
      event-sounds    = false;
    };
    "org/gnome/mutter" = {
      edge-tiling     = true;
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout   = "appmenu:minimize,maximize,close";
      num-workspaces  = 4;
    };
    "org/gnome/gnome-screenshot" = {
      auto-save-directory = "file://${host.homeDirectory}/Screenshots";
    };
  };

  programs.home-manager.enable = true;
}
