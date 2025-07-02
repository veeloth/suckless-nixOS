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
    appimage-run btop binutils_nogold caligula clang universal-ctags dmenu discordo
    fastfetch feh ffmpeg gh git gpick hmcl kitty lf
    librewolf mpv nasm neovim fractal vlc obs-studio
    obsidian p7zip pamixer qemu scrot sdl3
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tinycc tldr tmux xclip
    vesktop w3m-nographics yt-dlp zathura zulu23
  ] ++ ext-pkgs;
}
