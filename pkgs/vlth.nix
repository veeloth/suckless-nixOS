{ config, lib, pkgs, vebar, nhkd, pollymc, ... }:

let
  ext-pkgs =
    [
    vebar.packages."x86_64-linux".default
    nhkd.packages."x86_64-linux".default
    pollymc.packages."x86_64-linux".default
    ];
in
{
environment.systemPackages = with pkgs;
  [
    btop binutils_nogold clang dmenu
    fastfetch feh ffmpeg gh git gpick hmcl kitty lf
    librewolf mtpaint mpv nasm neovim vlc obs-studio
    obsidian osu-lazer-bin pamixer qemu scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tabbed tinycc tmux tuir xclip
    vesktop yt-dlp zathura zulu23
  ] ++ ext-pkgs;
}
