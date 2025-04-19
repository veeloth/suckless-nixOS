{ config, lib, pkgs, vebar, nhkd, ... }:

let
<<<<<<< HEAD
  localPkgs = [ vebar.packages."x86_64-linux".default nhkd.packages."x86_64-linux".default ];
=======
  localPkgs =
    [
    vebar.packages."x86_64-linux".default
    ];
>>>>>>> d7145fe655b1e7cddf9b0ff27492adc627258d59
in
{
environment.systemPackages = with pkgs;
  [
    btop binutils_nogold dissent dmenu
    fastfetch feh gh git gpick hmcl kitty librewolf
    mtpaint nasm neovim vlc obsidian
    osu-lazer-bin pamixer pandoc qemu scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tabbed tinycc tmux tuir xclip
    vesktop yt-dlp zathura zulu23
  ] ++ localPkgs;
}
