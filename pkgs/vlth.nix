{ config, lib, pkgs, vebar, nhkd, ... }:

let
  ext-pkgs =
    [
    vebar.packages."x86_64-linux".default
    nhkd.packages."x86_64-linux".default
    ];
in
{
environment.systemPackages = with pkgs;
  [
    appimage-run btop binutils_nogold clang dmenu discordo
    fastfetch feh ffmpeg gh git gpick hmcl kitty lf
    librewolf mpv nasm neovim vlc obs-studio
    obsidian osu-lazer-bin pamixer qemu scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tinycc tldr tmux xclip
    vesktop yt-dlp zathura zulu23
  ] ++ ext-pkgs;

pkgs.config.packageOverrides = pkgs: {
    appimage-run = pkgs.appimage-run.override {
      runtimeInputs =
        [pkgs.icu];
      };
    };

}
