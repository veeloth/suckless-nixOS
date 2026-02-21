{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation
  {
  pname = "nhkd";
  version = "22.1";
  src = ./src;

  buildInputs =
    [
    pkgs.pkg-config
    pkgs.gnumake
    pkgs.libX11
    ];

  buildPhase =
    ''
    make
    '';

  installPhase =
    ''
    mkdir -p $out/bin
    cp nhkd $out/bin
    '';
  }
