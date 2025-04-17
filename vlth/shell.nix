{ pkgs }:

{
  pkgs.writeShellScriptBin "o"
    ''
    #!/usr/bin/env bash
    clear
    cd $1
    tree -$2L 1
    pwd
    ''
  programs.bash.shellAliases = {
    o = ". ~/o";
    a = ". ~/o .";
    n = ". ~/o . && nvim";
    p = ". ~/o ..";
    f = "sudo nixos-rebuild switch --flake .#";
  };
}
