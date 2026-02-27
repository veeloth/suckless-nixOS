{ config, lib, pkgs, vebar, nhkd, osu, ... }:

let
  ext-pkgs =
    [
    vebar.packages."x86_64-linux".default
    nhkd.packages."x86_64-linux".default
    osu.packages."x86_64-linux".default#potential injury? won't play until july 20th
    ];
in
{
environment.systemPackages = with pkgs;
  [
    bluetui btop binutils_nogold caligula clang cron
    universal-ctags dmenu discordo
    fastfetch feh gh git gpick hmcl keynav lf
    librewolf jellyfin-ffmpeg man-pages mpv nautilus nasm neovim nix-search-cli vlc obs-studio
    obsidian p7zip pamixer python314 scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tinycc tldr tmux unison
    w3m-nographics xclip yt-dlp zathura zulu
  ] ++ ext-pkgs;
}
