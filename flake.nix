{
  description = "veeloth's suckless flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    vebar.url = "path:pkgs/vebar";
    nhkd.url = "path:pkgs/nhkd";
    osu.url = "path:pkgs/osu";
  };
  outputs = { self, nixpkgs, nixvim, vebar, nhkd, osu, ... }@attrs: {
    nixosConfigurations.vlth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./vlth/configuration.nix ];
    };
  };
}
