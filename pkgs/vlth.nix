{ config, lib, pkgs, vebar, nhkd, osu, ... }:

let
  ext-pkgs =
    [
    vebar.packages."x86_64-linux".default
    nhkd.packages."x86_64-linux".default
    osu.packages."x86_64-linux".default
    ];
in
{
environment.systemPackages = with pkgs;
  [
    btop binutils_nogold caligula clang
    universal-ctags dmenu discordo
    fastfetch feh ffmpeg gh git gpick hmcl lf
    librewolf mpv nasm neovim vlc obs-studio
    obsidian p7zip pamixer scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tinycc tldr tmux xclip
    w3m-nographics yt-dlp zathura zulu23
  ] ++ ext-pkgs;
}
