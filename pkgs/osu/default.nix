{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenvNoCC }:

let
  pname = "osu";
  version = "2025.607.0";
  src = pkgs.fetchurl
    {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    hash = "sha256-k09fyaSfGZgC7VoDp68+xb5wxiXGQllXKqCpz+7k0So=";
    };
in
  pkgs.appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      ;
    extraPkgs = pkgs: with pkgs; [ icu ];
    extraInstallCommands =
      let
        contents = pkgs.appimageTools.extract { inherit pname version src; };
      in
      ''
        . ${pkgs.makeWrapper}/nix-support/setup-hook
        mv -v $out/bin/${pname} $out/bin/osu!

        wrapProgram $out/bin/osu! \
          --set OSU_EXTERNAL_UPDATE_PROVIDER 1

        install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
        done
      '';
    }
