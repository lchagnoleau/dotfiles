{
  description = "BigMac nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, ... }:
  let
    configuration = { pkgs, ... }: {
      system.primaryUser = "lchagnoleau";
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.tmux
          pkgs.git
          pkgs.delta
          pkgs.eza
          pkgs.zoxide
          pkgs.jujutsu
          pkgs.lazygit
          pkgs.chezmoi
          pkgs.firefox
          pkgs.ghostty-bin
          pkgs.bitwarden-cli
          pkgs.ripgrep
          pkgs.podman
          pkgs.fzf
          pkgs.fd
        ];

      homebrew = {
        enable = true;
          casks = [
            "rectangle"
            "hyperkey"
            "maccy"
            "parallels"
            "microsoft-office"
            "microsoft-teams"
          ];
          brews = [
            "mole"
            "mas"
            "mise"
            "age"
            "fnox"
          ];
          masApps = {
            "WireGuard" = 1451685025;
          };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
        };

      fonts.packages =
        with pkgs; [
          nerd-fonts.hack
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

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
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."BigMac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "lchagnoleau";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
