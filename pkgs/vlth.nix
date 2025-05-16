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
    abaddon btop binutils_nogold clang cordless dmenu equicord
    fastfetch feh ffmpeg gh git gpick hmcl legcord kitty lf
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
