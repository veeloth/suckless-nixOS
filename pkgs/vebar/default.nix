{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation
  {
  pname = "vebar";
  version = "0.1";
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
