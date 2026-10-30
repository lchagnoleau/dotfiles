{
  description = "Nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # macOS
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Linux
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager, nixgl, ... }:
  let
    host = import ./host.nix;
    nixpkgsConfig = {
      allowUnfree = true;
      segger-jlink.acceptLicense = true;
      # segger-jlink pulls in an old Qt marked insecure on Linux
      allowInsecurePredicate = pkg: nixpkgs.lib.getName pkg == "segger-jlink-qt4";
    };
  in
  {
    darwinConfigurations.${host.hostname} = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit host self; };
      modules = [
        { nixpkgs.config = nixpkgsConfig; }
        ./darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };

    homeConfigurations.${host.hostname} = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        localSystem = host.system;
        config = nixpkgsConfig;
        # NixGL overlay to provide access to auto-wrapped graphics utilities
        overlays = [ nixgl.overlay ];
      };
      extraSpecialArgs = { inherit host; };
      modules = [
        ./linux.nix
      ];
    };
  };
}
