{ config, lib, pkgs, ... }:

{
  users.users.veeloth = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
  };
}
