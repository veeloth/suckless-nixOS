{ config, lib, pkgs, vebar, ... }:

let
  localPkgs = [ vebar.packages."x86_64-linux".default ];
in
{
environment.systemPackages = with pkgs;
  [
    btop binutils_nogold dmenu
    fastfetch feh gh git gpick hmcl librewolf
    mtpaint nasm neovim vlc obsidian
    osu-lazer-bin pamixer pandoc qemu scrot
    signal
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tabbed tinycc tmux tuir xclip
    vesktop yt-dlp zathura zulu23
  ] ++ localPkgs;
#environment.systemPackages = environment.systemPackages ++ [vebar.packages."x86_64-linux".vebar];
}
