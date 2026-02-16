{
  description = "veeloth's suckless flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    vebar.url = "path:pkgs/vebar";
    nhkd.url = "path:pkgs/nhkd";
    osu.url = "path:pkgs/osu";
  };
  outputs = { self, nixpkgs, nvf, vebar, nhkd, osu, ... }@attrs: {
    nixosConfigurations.vlth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./modules/configuration.nix ];
    };
  };
}
