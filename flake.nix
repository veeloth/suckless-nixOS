{
  description = "veeloth's suckless flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    vebar.url = "path:pkgs/vebar";
  };
  outputs = { self, nixpkgs, nixvim, vebar, ... }@attrs: {
    nixosConfigurations.vlth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./vlth/configuration.nix ];
    };
  };
}
