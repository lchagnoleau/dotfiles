{ pkgs, host, self, ... }:
{
  system.primaryUser = host.username;
  nixpkgs.hostPlatform = host.system;

  environment.systemPackages = import ./packages.nix pkgs ++ [
    pkgs.container
    pkgs.wireguard-tools
    pkgs.ghostty-bin
    pkgs.bitwarden-desktop
    pkgs.firefox
    pkgs.mas
  ];

  fonts.packages = [ pkgs.nerd-fonts.hack ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = host.username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "rectangle"
      "hyperkey"
      "maccy"
      "slack"
      "calibre"
      "autodesk-fusion"
    ];
    brews = [
      "libusb"
      "mole"
    ];
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # MacOs settings
  system.defaults = {
    dock.show-recents = false;
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.4;
    dock.tilesize = 48;
    dock.largesize = 64;
    dock.mru-spaces = false;
    dock.minimize-to-application = true;
    dock.magnification = true;
    dock.show-process-indicators = false;
    dock.scroll-to-open = true;
    dock.static-only = true;
    dock.persistent-apps = [
      "${pkgs.ghostty-bin}/Applications/Ghostty.app"
      "${pkgs.firefox}/Applications/Firefox.app"
    ];
    controlcenter.FocusModes = false;
    finder.FXPreferredViewStyle = "clmv";
    finder.AppleShowAllExtensions = true;
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    finder.AppleShowAllFiles = false;
    finder.NewWindowTarget = "Home";
    screencapture.location = "~/Screenshots";
    loginwindow.GuestEnabled = false;
    trackpad.Clicking = true;
    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = 0;
    CustomUserPreferences.NSGlobalDomain."com.apple.mouse.linear" = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    NSGlobalDomain."com.apple.sound.beep.feedback" = 0;
    NSGlobalDomain."com.apple.trackpad.scaling" = 2.5;
  };
}
