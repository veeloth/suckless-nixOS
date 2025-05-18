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
    btop binutils_nogold clang cordless dmenu dissent discordo
    fastfetch feh ffmpeg gh git gpick gruvbox-dark-gtk hmcl kitty lf
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
