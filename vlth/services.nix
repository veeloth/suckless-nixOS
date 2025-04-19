{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager =
	{
	dwm.enable = true;
	dwm.package = (pkgs.dwm.overrideDerivation
	  (old: {
	  src = ../pkgs/dwm;
	  }));
	i3.enable = true;
	tinywm.enable = true;
	};
      excludePackages = [ pkgs.xterm ];
      exportConfiguration = true;
      xkb = { layout = "latam"; };
    };
    libinput = {
      mouse = {
        accelSpeed = "-0.6";
	accelProfile = "flat";
	};
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    displayManager.ly.enable = true;
    locate.enable = true;
  };
}
