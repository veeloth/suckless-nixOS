{ config, lib, pkgs, ... }:

{
  programs.bash.shellAliases = {
    o = ". ~/o";
    a = ". ~/o .";
    n = ". ~/o . && nvim";
    p = ". ~/o ..";
    f = "sudo nixos-rebuild switch --flake .#";
    clip = "xclip -selection clipboard -i";
    hakuneko = "hakuneko --no-sandbox";
  };
}
