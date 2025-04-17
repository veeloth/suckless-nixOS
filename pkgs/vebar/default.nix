{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation
  {
  name = "vebar";
  src = ./src;

  buildPhase =
    ''
    gcc vebar.c -o vebar
    '';

  installPhase =
    ''
    mkdir -p $out/bin
    cp vebar $out/bin
    '';
  }
