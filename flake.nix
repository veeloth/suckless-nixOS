{
  description = "veeloth's suckless flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    vebar.url = "path:pkgs/vebar";
    nhkd.url = "path:pkgs/nhkd";
  };
  outputs = { self, nixpkgs, nixvim, vebar, nhkd, ... }@attrs: {
    nixosConfigurations.vlth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./vlth/configuration.nix ];
    };
  };
}
