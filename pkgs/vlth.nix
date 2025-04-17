{ config, lib, pkgs, vebar, ... }:

let
  localPkgs =
    [
    vebar.packages."x86_64-linux".default
    (import ../vlth/shell.nix {inherit pkgs;} )
    ];
in
{
environment.systemPackages = with pkgs;
  [
    btop binutils_nogold discord dmenu
    fastfetch feh gh git gpick hmcl librewolf
    mtpaint nasm neovim vlc obsidian
    osu-lazer-bin pamixer pandoc qemu scrot
    (st.overrideDerivation
      (old: {
      src = ./st;
      })
    )
    tabbed tinycc tmux tuir xclip
    yt-dlp zathura zulu23
  ] ++ localPkgs;
#environment.systemPackages = environment.systemPackages ++ [vebar.packages."x86_64-linux".vebar];
}
